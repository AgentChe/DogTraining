//
//  CreateEventViewModel.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 28.08.2023.
//

import RxSwift
import RxCocoa

final class CreateEventViewModel {
    enum Route {
        case created, removed
    }
    
    private lazy var eventsManager = EventsManager()
    
    private let mode: CreateEventViewController.Mode
    
    init(mode: CreateEventViewController.Mode) {
        self.mode = mode
    }
}

// MARK: Public
extension CreateEventViewModel {
    struct Input {
        let didChangeNote: Signal<String>
        let didChangeDate: Signal<Date>
        let didChangeRepeatMode: Signal<EventRepeatMode>
        let didTapCreate: Signal<Void>
        let didTapRemove: Signal<Void>
    }
    
    struct Output {
        let enableSave: Driver<Bool>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let data = makeData(
            didChangeNote: input.didChangeNote,
            didChangeDate: input.didChangeDate,
            didChangeRepeatMode: input.didChangeRepeatMode
        )
        
        return Output(
            enableSave: makeEnableSave(data: data),
            route: makeRoute(
                didCreate: input.didTapCreate,
                data: data,
                didRemove: input.didTapRemove
            )
        )
    }
}

// MARK: Private
private extension CreateEventViewModel {
    struct Data {
        let note: String
        let date: Date
        let repeatMode: EventRepeatMode
    }
    
    func makeRoute(
        didCreate: Signal<Void>,
        data: Driver<Data>,
        didRemove: Signal<Void>
    ) -> Driver<Route> {
        let create = didCreate
            .withLatestFrom(data)
            .flatMapLatest { [weak self] data -> Driver<Route> in
                guard let self else {
                    return .never()
                }
                
                let eventId: String
                
                switch self.mode {
                case .create:
                    eventId = UUID().uuidString
                case .edit(let input):
                    eventId = input.id
                }
                
                let event = Event(
                    id: eventId,
                    type: self.mode.eventType,
                    note: data.note,
                    date: data.date,
                    repeatMode: data.repeatMode
                )
                
                return self.eventsManager
                    .add(event: event)
                    .map { Route.created }
                    .asDriver(onErrorDriveWith: .never())
            }
            .asDriver(onErrorDriveWith: .never())
        
        let remove = didRemove
            .flatMapLatest { [weak self] void -> Driver<Route> in
                guard let self, let eventId = self.mode.eventId else {
                    return .never()
                }
                
                return self.eventsManager
                    .delete(eventId: eventId)
                    .map { Route.removed }
                    .asDriver(onErrorDriveWith: .never())
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(create, remove)
    }
    
    func makeEnableSave(data: Driver<Data>) -> Driver<Bool> {
        data
            .map { data -> Bool in
                !data.note.isEmpty
            }
            .startWith(false)
    }
    
    func makeData(
        didChangeNote: Signal<String>,
        didChangeDate: Signal<Date>,
        didChangeRepeatMode: Signal<EventRepeatMode>
    ) -> Driver<Data> {
        Signal
            .combineLatest(
                didChangeNote,
                didChangeDate,
                didChangeRepeatMode
            )
            .map { note, date, repeatMode -> Data in
                Data(
                    note: note,
                    date: date,
                    repeatMode: repeatMode
                )
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
