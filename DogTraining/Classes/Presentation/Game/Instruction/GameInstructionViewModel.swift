//
//  GameInstructionViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import RxSwift
import RxCocoa

final class GameInstructionViewModel {
    enum Route {
        case training(customerGameId: Int)
        case calendar(customerGameId: Int)
    }
    
    enum Source {
        case game(Game)
        case planGame(PlanGame)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTapStartTraining = PublishRelay<Void>()
    lazy var didTapCalendar = PublishRelay<Void>()
    lazy var didTapShowMore = PublishRelay<Void>()
    
    lazy var route = makeRoute()
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    lazy var assignActivity = RxActivityIndicator()
    
    private let source: Driver<Source>
    private lazy var game = makeGame()
    private lazy var gamesGroups = makeGamesGroups()
    private lazy var skillLevels = makeSkillLevels()
    private lazy var showMore = makeShowMore()
    
    private lazy var gamesManager = GamesManager()
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(source: Source) {
        self.source = BehaviorRelay(value: source).asDriver()
    }
}

// MARK: Private
private extension GameInstructionViewModel {
    func makeRoute() -> Driver<Route> {
        let calendarRoute = didTapCalendar
            .withLatestFrom(game)
            .flatMapLatest { [weak self] game -> Driver<Route> in
                guard let self else {  return .never() }
                
                func source() -> Single<Route> {
                    self.gamesManager
                        .assignGame(id: game.id)
                        .flatMap { assignedGame -> Single<Route> in
                            guard let assignedGame = assignedGame else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(.calendar(customerGameId: assignedGame.customerGameId))
                        }
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
                    .trackActivity(self.assignActivity)
                    .asDriver(onErrorDriveWith: .never())
            }
            .asDriver(onErrorDriveWith: .never())
        
        let trainingRoute = didTapStartTraining
            .withLatestFrom(source)
            .flatMapLatest { [weak self] input -> Driver<Route> in
                guard let self = self else {
                    return .never()
                }
                
                switch input {
                case .game(let game):
                    func source() -> Single<Route> {
                        self.gamesManager
                            .assignGame(id: game.id)
                            .flatMap { assignedGame -> Single<Route> in
                                guard let assignedGame = assignedGame else {
                                    return .error(ContentError(.notContent))
                                }
                                
                                return .just(.training(customerGameId: assignedGame.customerGameId))
                            }
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
                        .trackActivity(self.assignActivity)
                        .asDriver(onErrorDriveWith: .never())
                case .planGame(let planGame):
                    return .just(.training(customerGameId: planGame.customerGameId))
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(calendarRoute, trainingRoute)
    }
    
    func makeElements() -> Driver<[GITableElement]> {
        Driver
            .combineLatest(game, gamesGroups, skillLevels, showMore)
            .map { game, gamesGroups, skillLevels, showMore -> [GITableElement] in
                var result = [GITableElement]()
                
                let headerElement = GIHeaderElement(
                    image: game.image,
                    name: game.name,
                    skillLevel: skillLevels.first(where: { $0.id == game.skillLevelId })?.name ?? "",
                    gameGroup: gamesGroups.first(where: { $0.id == game.gameGroupId })?.name ?? ""
                )
                result.append(.header(headerElement))
                
                let descriptionElement = GIDescriptionElement(
                    description: game.explanation,
                    isFull: showMore
                )
                result.append(contentsOf: [
                    .offset(16.scale),
                    .description(descriptionElement)
                ])
                
                result.append(contentsOf: [
                    .offset(16.scale),
                    .buttons("GameInstruction.StartGame".localized)
                ])
                
                result.append(contentsOf: [
                    .offset(24.scale),
                    .instruction(game.instruction)
                ])
                
                return result
            }
    }
    
    func makeGame() -> Driver<Game> {
        source
            .flatMapLatest { [weak self] input -> Driver<Game> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Game> {
                    switch input {
                    case .game(let game):
                        return .just(game)
                    case .planGame(let planGame):
                        return self.gamesManager
                            .obtainGameTraining(customerGameId: planGame.customerGameId)
                            .flatMap { planGame -> Single<Game> in
                                guard let planGame = planGame else {
                                    return .error(ContentError(.notContent))
                                }
                                
                                return .just(planGame.game)
                            }
                    }
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
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeGamesGroups() -> Driver<[GameGroup]> {
        gamesManager
            .obtainGameGroups(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeShowMore() -> Driver<Bool> {
        didTapShowMore
            .asDriver(onErrorDriveWith: .never())
            .map { true }
            .startWith(false)
    }
}
