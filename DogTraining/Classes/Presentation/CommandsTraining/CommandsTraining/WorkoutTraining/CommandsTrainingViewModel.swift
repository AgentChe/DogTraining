//
//  CommandsTrainingViewModel.swift
//  Soccer
//
//  Created by Виталий Загороднов on 23.03.2023.
//

import RxSwift
import RxCocoa

final class CommandsTrainingViewModel {
    enum Route {
        case finished(TrainingDetails)
    }
    
    enum MenuState {
        case first
        case middle
        case last
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var currentAndNextCommand = makeCurrentAndNextCommand()
    lazy var currentIndex = makeCurrentIndex()
    lazy var commands = trainingDetails.map { $0.training.commands }
    lazy var menuState = makeMenuState()
    lazy var route = makeRoute()
    
    lazy var didFinishCommand = PublishRelay<(time: Int, id: Int)>()
    lazy var didFinishTraining = PublishRelay<(time: Int, id: Int)>()
    lazy var didTapNext = PublishRelay<Void>()
    lazy var didTapPrevios = PublishRelay<Void>()
    
    lazy var activity = RxActivityIndicator()
    
    private lazy var trainingDetails = makeTrainingDetails()
    private let customerTrainingId: Driver<Int>
    
    private lazy var trainingsManager = TrainingsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(customerTrainingId: Int) {
        self.customerTrainingId = BehaviorRelay(value: customerTrainingId).asDriver()
    }
}

// MARK: Private
private extension CommandsTrainingViewModel {
    func makeTrainingDetails() -> Driver<TrainingDetails> {
        customerTrainingId
            .flatMapLatest { [weak self] customerTrainingId in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<TrainingDetails> {
                    self.trainingsManager
                        .obtainTrainingDetails(customerTrainingId: customerTrainingId)
                        .map { trainingDetails  in
                            guard let trainingDetails else {
                                throw ContentError(.notContent)
                            }
                            
                            return trainingDetails
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(
                        source: source,
                        trigger: trigger
                    )
                    .trackActivity(self.activity)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func saveProgress(customerTrainingId: Int, commandId: Int, trainedTime: Int, finish: Bool) -> Observable<AssignedTraining?> {
        func source() -> Single<AssignedTraining?> {
            trainingsManager.logProgress(
                customerTrainingId: customerTrainingId,
                trainedTime: trainedTime,
                finish: finish,
                commandId: commandId
            )
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        return observableRetrySingle
            .retry(
                source: source,
                trigger: trigger
            )
            .asObservable()
    }
    
    func makeRoute() -> Signal<Route> {
        let customerTrainingId = trainingDetails
            .map(\.assignedTraining.customerTrainingId)
            .asObservable()
        
        let finishTraining = didFinishTraining
            .withLatestFrom(customerTrainingId) { ($0, $1) }
            .flatMapLatest { [weak self] args -> Observable<Route?> in
                guard let self = self else {
                    return .never()
                }
                
                let ((time, commandId), customerTrainingId) = args
                
                return self.saveProgress(
                    customerTrainingId: customerTrainingId,
                    commandId: commandId,
                    trainedTime: time,
                    finish: true
                )
                .withLatestFrom(self.trainingDetails) { ($0, $1) }
                .map { assignedTraining, trainingDetails -> Route? in
                    guard let assignedTraining else {
                        return nil
                    }
                    
                    let training = TrainingDetails(training: trainingDetails.training, assignedTraining: assignedTraining)
                    return .finished(training)
                }
                .trackActivity(self.activity)
            }
        
        let finishCommand = didFinishCommand
            .withLatestFrom(customerTrainingId) { ($0, $1) }
            .flatMapLatest { [weak self] args -> Observable<Route?> in
                guard let self = self else {
                    return .never()
                }
                
                let ((time, commandId), customerTrainingId) = args
                
                return self.saveProgress(
                    customerTrainingId: customerTrainingId,
                    commandId: commandId,
                    trainedTime: time,
                    finish: false
                )
                .map { _ in nil }
            }
        
        return Observable
            .merge(finishTraining, finishCommand)
            .compactMap { $0 }
            .asSignal(onErrorSignalWith: .never())
    }
    
    func makeCurrentAndNextCommand() -> Driver<(current: Command, next: Command?)> {
        currentIndex
            .withLatestFrom(commands) { ($0, $1) }
            .compactMap { currentIndex, commands in
                guard let current = commands[safe: currentIndex] else {
                    return nil
                }
                
                return (current, commands[safe: currentIndex + 1])
            }
    }
    
    func makeCurrentIndex() -> Driver<Int> {
        enum Action {
            case next
            case previos
            case set([Command])
        }
        
        let initial: (elements: [Command], index: Int?) = ([], nil)
        
        return Observable<Action>
            .merge(
                didTapNext.map { .next },
                didTapPrevios.map { .previos },
                trainingDetails.asObservable().map { .set($0.training.commands) }
            )
            .scan(into: initial) { result, action in
                switch action {
                case .next:
                    guard let currentIndex = result.index else {
                        return
                    }
                    
                    result.index = result.elements.indices.contains(currentIndex + 1) ? currentIndex + 1 : currentIndex
                case .previos:
                    guard let currentIndex = result.index else {
                        return
                    }
                    
                    result.index = result.elements.indices.contains(currentIndex - 1) ? currentIndex - 1 : currentIndex
                case let .set(elements):
                    guard elements.count > 0 else {
                        return
                    }
                    result.elements = elements
                    result.index = 0
                }
            }
            .compactMap { $0.index }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeMenuState() -> Driver<MenuState> {
       Driver
            .combineLatest(currentIndex, commands)
            .compactMap { currentIndex, commands -> MenuState? in
                guard currentIndex < (commands.count - 1) else {
                    return .last
                }
                
                guard
                    let currentCommand = commands[safe: currentIndex],
                    let index = commands.firstIndex(of: currentCommand)
                else {
                    return nil
                }
            
                return index == 0 ? .first : .middle
            }
    }
}
