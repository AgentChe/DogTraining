//
//  EventsManager.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 26.08.2023.
//

import RxSwift
import RxCocoa

protocol EventsManagerProtocol {
    func add(event: Event) -> Single<Void>
    func obtainEvents() -> Single<[Event]>
    func delete(eventId: String) -> Single<Void>
}

final class EventsManager {
    enum Constants {
        static let events = "events_manager_events_key"
    }
}

// MARK: EventsManagerProtocol
extension EventsManager: EventsManagerProtocol {
    func add(event: Event) -> Single<Void> {
        Single<Void>.create { single in
            var events: [Event] = []
            
            if let data = UserDefaults.standard.data(forKey: Constants.events) {
                events = (try? JSONDecoder().decode([Event].self, from: data)) ?? []
            }
            
            if let index = events.firstIndex(where: { $0.id == event.id }) {
                events[index] = event
            } else {
                events.append(event)
            }
            
            if let data = try? JSONEncoder().encode(events) {
                UserDefaults.standard.set(data, forKey: Constants.events)
            }
            
            single(.success(Void()))
            
            EventsMediator.shared.add(event: event)
            
            return Disposables.create()
        }
    }
    
    func obtainEvents() -> Single<[Event]> {
        Single<[Event]>.create { single in
            var events: [Event] = []
            
            if let data = UserDefaults.standard.data(forKey: Constants.events) {
                events = (try? JSONDecoder().decode([Event].self, from: data)) ?? []
            }
            
            single(.success(events))
            
            return Disposables.create()
        }
    }
    
    func delete(eventId: String) -> Single<Void> {
        Single<Void>.create { single in
            var events: [Event] = []
            
            if let data = UserDefaults.standard.data(forKey: Constants.events) {
                events = (try? JSONDecoder().decode([Event].self, from: data)) ?? []
            }
            
            events.removeAll(where: { $0.id == eventId })
            
            if let data = try? JSONEncoder().encode(events) {
                UserDefaults.standard.set(data, forKey: Constants.events)
            }
            
            single(.success(Void()))
            
            EventsMediator.shared.delete(eventId: eventId)
            
            return Disposables.create()
        }
    }
}
