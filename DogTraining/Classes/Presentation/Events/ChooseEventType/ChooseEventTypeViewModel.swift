//
//  ChooseEventTypeViewModel.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 28.08.2023.
//

import RxSwift
import RxCocoa

final class ChooseEventTypeViewModel {
    enum Route {
        case create(EventType)
    }
}

// MARK: Public
extension ChooseEventTypeViewModel {
    struct Input {
        let didSelectElement: Signal<EventType>
    }
    
    struct Output {
        let elements: Driver<[EventType]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(),
            route: makeRoute(didSelectElement: input.didSelectElement)
        )
    }
}

// MARK: Private
private extension ChooseEventTypeViewModel {
    func makeElements() -> Driver<[EventType]> {
        Single<[EventType]>
            .create { single in
                single(.success(EventType.allCases))
                
                return Disposables.create()
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeRoute(didSelectElement: Signal<EventType>) -> Driver<Route> {
        didSelectElement
            .map { Route.create($0) }
            .asDriver(onErrorDriveWith: .never())
    }
}
