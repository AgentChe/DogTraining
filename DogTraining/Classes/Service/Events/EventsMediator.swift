//
//  EventsMediator.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 26.08.2023.
//

import RxSwift
import RxCocoa

final class EventsMediator {
    static let shared = EventsMediator()
    
    private init() {}
    
    private lazy var didAddTrigger = PublishRelay<Event>()
    private lazy var didDeleteTrigger = PublishRelay<String>()
}

// MARK: Public
extension EventsMediator {
    func add(event: Event) {
        DispatchQueue.main.async { [weak self] in
            self?.didAddTrigger.accept(event)
        }
    }
    
    func delete(eventId: String) {
        DispatchQueue.main.async { [weak self] in
            self?.didDeleteTrigger.accept(eventId)
        }
    }
    
    var didAdd: Signal<Event> {
        didAddTrigger.asSignal()
    }
    
    var didDelete: Signal<String> {
        didDeleteTrigger.asSignal()
    }
}
