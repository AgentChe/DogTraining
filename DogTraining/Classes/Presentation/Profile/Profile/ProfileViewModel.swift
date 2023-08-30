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
        let events = makeEvents()
        
        return Output(
            elements: makeElements(
                homeKit: homeKit,
                skillLevels: skillLevels,
                name: name,
                eventsDay: eventsDay,
                events: events
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
                case .event(let element):
                    return .openEvent(element.event)
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
        events: Driver<[Event]>
    ) -> Driver<[ProfileTableElement]> {
        Driver.combineLatest(homeKit, skillLevels, name, eventsDay, events)
            .map { [weak self] homeKit, skillLevels, name, eventsDay, events -> [ProfileTableElement] in
                guard let self else {
                    return []
                }
                
                var result = [ProfileTableElement]()
                
                result.append(.settings(name))
                
                if let level = skillLevels.first(where: { $0.id == homeKit.levelId }) {
                    result.append(.progress(percent: homeKit.score, level: level.name))
                }
                
                result.append(.calendar)
                
                self.group(events: events, day: eventsDay).forEach { element in
                    result.append(.event(element))
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
    
    func makeEvents() -> Driver<[Event]> {
        Signal
            .merge(
                EventsMediator.shared.didAdd.map { event in Void() },
                EventsMediator.shared.didDelete.map { id in Void() }
            )
            .startWith(Void())
            .flatMapLatest { [weak self] void -> Driver<[Event]> in
                guard let self else {
                    return .never()
                }
                
                return self.eventsManager
                    .obtainEvents()
                    .asDriver(onErrorJustReturn: [])
            }
    }
}

// MARK: Private(Additional)
private extension ProfileViewModel {
    func group(events: [Event], day: Date) -> [ProfileEventElement] {
        let calendar = Calendar.current
        
        var result = [ProfileEventElement]()
        
        func makeElement(event: Event) -> ProfileEventElement? {
            var dateComponents = DateComponents()
            dateComponents.hour = calendar.component(.hour, from: event.date)
            dateComponents.minute = calendar.component(.minute, from: event.date)
            dateComponents.day = calendar.component(.day, from: day)
            dateComponents.month = calendar.component(.month, from: day)
            dateComponents.year = calendar.component(.year, from: day)
            
            guard let date = calendar.date(from: dateComponents) else {
                return nil
            }
            
            return ProfileEventElement(event: event, date: date)
        }
        
        events.forEach { event in
            var element: ProfileEventElement?
            
            if event.date.isEqualByDays(with: day) {
                element = ProfileEventElement(event: event, date: event.date)
            } else {
                switch event.repeatMode {
                case .never:
                    element = nil
                case .daily:
                    element = ProfileEventElement(event: event, date: event.date)
                case .weekly:
                    let dayDate = calendar.startOfDay(for: day)
                    let eventDate = calendar.startOfDay(for: event.date)
                    guard let days = calendar.dateComponents([.day], from: eventDate, to: dayDate).day else {
                        return
                    }
                    
                    if days >= 0, (days % 7) == 0 {
                        element = makeElement(event: event)
                    }
                case .monthly:
                    if calendar.dateComponents([.day], from: event.date) == calendar.dateComponents([.day], from: day) {
                        element = makeElement(event: event)
                    }
                case .yearly:
                    let components: Set<Calendar.Component> = [.day, .month]
                    if calendar.dateComponents(components, from: event.date) == calendar.dateComponents(components, from: day) {
                        element = makeElement(event: event)
                    }
                }
            }
            
            if let element = element {
                result.append(element)
            }
        }
        
        return result
    }
}
