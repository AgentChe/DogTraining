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
    enum Route {
        case settings, addEvent
        case openEvent(Event)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var contentManager = ContentManager()
    private lazy var profileManager = ProfileManager()
    private lazy var eventsManager = EventsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension ProfileViewModel {
    struct Input {
        let didSelectElement: Signal<ProfileTableElement>
        let didSelectDay: Signal<Date>
    }
    
    struct Output {
        let elements: Driver<[ProfileTableElement]>
        let activity: Driver<Bool>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let homeKit = makeHomeKit()
        let skillLevels = makeSkillLevels()
        let name = makeName()
        let eventsDay = makeEventsDay(didTapDay: input.didSelectDay)
        let eventsOnDays = makeEventsOnDays()
        
        return Output(
            elements: makeElements(
                homeKit: homeKit,
                skillLevels: skillLevels,
                name: name,
                eventsDay: eventsDay,
                eventsOnDays: eventsOnDays
            ),
            activity: activity.asDriver(),
            route: makeRoute(didSelectElement: input.didSelectElement)
        )
    }
}

// MARK: Private
private extension ProfileViewModel {
    func makeRoute(didSelectElement: Signal<ProfileTableElement>) -> Driver<Route> {
        didSelectElement
            .compactMap { element -> Route? in
                switch element {
                case .settings:
                    return .settings
                case .addEvent:
                    return .addEvent
                case .event(let event):
                    return .openEvent(event)
                default:
                    return nil
                }
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeElements(
        homeKit: Driver<HomeKit>,
        skillLevels: Driver<[SkillLevel]>,
        name: Driver<String>,
        eventsDay: Driver<Date>,
        eventsOnDays: Driver<[EventsOnDay]>
    ) -> Driver<[ProfileTableElement]> {
        Driver.combineLatest(homeKit, skillLevels, name, eventsDay, eventsOnDays)
            .map { homeKit, skillLevels, name, eventsDay, eventsOnDays -> [ProfileTableElement] in
                var result = [ProfileTableElement]()
                
                result.append(.settings(name))
                
                if let level = skillLevels.first(where: { $0.id == homeKit.levelId }) {
                    result.append(.progress(percent: homeKit.score, level: level.name))
                }
                
                result.append(.calendar)
                
                // TODO: добавлять повторения
                if let eventsOnDay = eventsOnDays.first(where: { $0.day.isEqualByDays(with: eventsDay) }), !eventsOnDay.events.isEmpty {
                    eventsOnDay.events.forEach { result.append(.event($0)) }
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
    
    func makeEventsDay(didTapDay: Signal<Date>) -> Driver<Date> {
        didTapDay
            .startWith(Calendar.current.startOfDay(for: Date()))
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeEventsOnDays() -> Driver<[EventsOnDay]> {
        Signal
            .merge(
                EventsMediator.shared.didAdd.map { event in Void() },
                EventsMediator.shared.didDelete.map { id in Void() }
            )
            .startWith(Void())
            .flatMapLatest { [weak self] void -> Driver<[EventsOnDay]> in
                guard let self else {
                    return .never()
                }
                
                return self.eventsManager
                    .obtainEventsOnDays()
                    .asDriver(onErrorJustReturn: [])
            }
    }
}
