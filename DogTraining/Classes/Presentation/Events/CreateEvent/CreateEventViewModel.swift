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
        case created
    }
    
    private lazy var eventsManager = EventsManager()
    
    private let eventType: EventType
    
    init(eventType: EventType) {
        self.eventType = eventType
    }
}

// MARK: Public
extension CreateEventViewModel {
    struct Input {
        let didChangeNote: Signal<String>
        let didChangeDate: Signal<Date>
        let didChangeRepeatMode: Signal<EventRepeatMode>
        let didTapCreate: Signal<Void>
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
                data: data
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
    
    func makeRoute(didCreate: Signal<Void>, data: Driver<Data>) -> Driver<Route> {
        didCreate
            .withLatestFrom(data)
            .flatMapLatest { [weak self] data -> Driver<Route> in
                guard let self else {
                    return .never()
                }
                
                let event = Event(
                    id: UUID().uuidString,
                    type: self.eventType,
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
