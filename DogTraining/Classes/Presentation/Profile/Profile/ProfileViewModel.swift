//
//  ProfileViewModel.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var contentManager = ContentManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension ProfileViewModel {
    struct Input {}
    
    struct Output {
        let elements: Driver<[ProfileTableElement]>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let homeKit = makeHomeKit()
        let skillLevels = makeSkillLevels()
        let name = makeName()
        
        return Output(
            elements: makeElements(
                homeKit: homeKit,
                skillLevels: skillLevels,
                name: name
            ),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension ProfileViewModel {
    func makeElements(
        homeKit: Driver<HomeKit>,
        skillLevels: Driver<[SkillLevel]>,
        name: Driver<String>
    ) -> Driver<[ProfileTableElement]> {
        Driver.combineLatest(homeKit, skillLevels, name)
            .map { homeKit, skillLevels, name -> [ProfileTableElement] in
                var result = [ProfileTableElement]()
                
                result.append(.settings(name))
                
                if let level = skillLevels.first(where: { $0.id == homeKit.levelId }) {
                    result.append(.progress(percent: homeKit.score, level: level.name))
                }
                
                result.append(.addEvent)
                
                let commandsCompleted = homeKit.plan
                    .flatMap { plan -> [PlanCommand] in
                        plan.commands.filter { $0.status == .completed }
                    }
                let trainingsCompleted = homeKit.plan
                    .flatMap { plan  -> [PlanTraining] in
                        plan.trainings.filter { $0.status == .completed }
                    }
                let gamesCompleted = homeKit.plan
                    .flatMap { plan -> [PlanGame] in
                        plan.games.filter { $0.status == .completed }
                    }
                result.append(.stats(
                    commands: "\(commandsCompleted.count)",
                    trainings: "\(trainingsCompleted.count)",
                    games: "\(gamesCompleted.count)")
                )
                
                return result
            }
    }
    
    func makeHomeKit() -> Driver<HomeKit> {
        let triggers = Signal<Void>.merge(
            TrainingsMediator.shared.didLogProgress.map { _ in Void() },
            TrainingsMediator.shared.didSchedule.map { _ in Void() },
            CommandsMediator.shared.didLogProgress.map { _ in Void() },
            CommandsMediator.shared.didSchedule.map { _ in Void() },
            GamesMediator.shared.didLogProgress.map { _ in Void() },
            GamesMediator.shared.didSchedule.map { _ in Void() },
            PlanMediator.shared.didReinit.map { _ in Void() }
        )
        
        return triggers
            .startWith(Void())
            .flatMapLatest { [weak self] void -> Driver<HomeKit> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<HomeKit> {
                    self.contentManager
                        .obtainHomeKit()
                        .map { homeKit -> HomeKit in
                            guard let homeKit else {
                                throw ContentError(.notContent)
                            }
                            
                            return homeKit
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
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeName() -> Driver<String> {
        profileManager
            .obtainProfile(forceUpdate: false)
            .map { $0?.name ?? "" }
            .asDriver(onErrorJustReturn: "")
    }
}
