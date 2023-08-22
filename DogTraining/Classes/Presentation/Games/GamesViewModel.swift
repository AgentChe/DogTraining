//
//  GamesViewModel.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 22.08.2023.
//

import RxSwift
import RxCocoa

final class GamesViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let gamesGroup: Driver<GameGroup?>
    private lazy var activity = RxActivityIndicator()
    
    private lazy var gamesManager = GamesManager()
    private lazy var sessionManager = SessionManager()
    private lazy var contentManager = ContentManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(gamesGroup: GameGroup?) {
        self.gamesGroup = BehaviorRelay(value: gamesGroup).asDriver()
    }
}

// MARK: Public
extension GamesViewModel {
    struct Input {}
    
    struct Output {
        let activity: Driver<Bool>
        let elements: Driver<[GamesTableElement]>
    }
    
    func configure(input: Input) -> Output {
        let gamesGroups = makeGamesGroups()
        let profile = makeProfile()
        let games = makeGames(gamesGroup: gamesGroup, profile: profile)
        let activeSubscription = makeActiveSubscription()
        let skillLevels = makeSkillLevels()
        
        return Output(
            activity: activity.asDriver(),
            elements: makeElements(
                gamesGroups: gamesGroups,
                games: games,
                activeSubscription: activeSubscription,
                skillLevels: skillLevels
            )
        )
    }
}

// MARK: Private
private extension GamesViewModel {
    func makeElements(
        gamesGroups: Driver<[GameGroup]>,
        games: Driver<[Game]>,
        activeSubscription: Driver<Bool>,
        skillLevels: Driver<[SkillLevel]>
    ) -> Driver<[GamesTableElement]> {
        Driver
            .combineLatest(gamesGroups, games, activeSubscription, skillLevels)
            .map { gamesGroups, games, activeSubscription, skillLevels -> [GamesTableElement] in
                games.compactMap { game -> GamesTableElement? in
                    guard
                        let gamesGroup = gamesGroups.first(where: { $0.id == game.gameGroupId }),
                        let skillLevel = skillLevels.first(where: { $0.id == game.skillLevelId })
                    else {
                        return nil
                    }
                    
                    return GamesTableElement(
                        game: game,
                        gamesGroup: gamesGroup,
                        skillLevel: skillLevel,
                        locked: game.paid ? !activeSubscription : false
                    )
                }
            }
    }
    
    func makeGames(
        gamesGroup: Driver<GameGroup?>,
        profile: Driver<Profile?>
    ) -> Driver<[Game]> {
        Driver
            .combineLatest(gamesGroup, profile)
            .flatMapLatest { [weak self] gamesGroup, profile -> Driver<[Game]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[Game]> {
                    self.gamesManager
                        .obtainGames(
                            gameGroupId: gamesGroup?.id,
                            levelId: profile?.skillLevelId
                        )
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeGamesGroups() -> Driver<[GameGroup]> {
        gamesManager
            .obtainGameGroups(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeProfile() -> Driver<Profile?> {
        profileManager
            .obtainProfile(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { [weak self] in
                guard let self = self else {
                    return false
                }
                
                return self.sessionManager.hasActiveSubscriptions()
            }
            .startWith(sessionManager.hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
