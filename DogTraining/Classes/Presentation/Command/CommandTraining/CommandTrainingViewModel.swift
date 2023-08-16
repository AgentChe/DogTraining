//
//  CommandTrainingViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import RxSwift
import RxCocoa

final class CommandTrainingViewModel {
    enum Route {
        case finished(CommandTraining)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didFinishTraining = PublishRelay<Int>()
    
    lazy var activity = RxActivityIndicator()
    lazy var route = makeRoute()
    lazy var startTraining = makeStartTraining()
    lazy var command = makeCommand()
    
    private lazy var commandTraining = makeCommandTraining()
    private let customerCommandId: Driver<Int>
    
    private lazy var commandsManager = CommandsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(customerCommandId: Int) {
        self.customerCommandId = BehaviorRelay(value: customerCommandId).asDriver()
    }
}

// MARK: Private
private extension CommandTrainingViewModel {
    func makeRoute() -> Driver<Route> {
        didFinishTraining
            .withLatestFrom(commandTraining) { ($0, $1) }
            .flatMapLatest { [weak self] totalSeconds, commandTraining -> Observable<CommandTraining> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<CommandTraining> {
                    self.commandsManager
                        .logProgress(
                            customerCommandId: commandTraining.assignedCommand.customerCommandId,
                            trainedTime: totalSeconds,
                            finish: true
                        )
                        .flatMap { assignedCommand -> Single<CommandTraining> in
                            guard let assignedCommand = assignedCommand else {
                                return .error(ContentError(.notContent))
                            }
                            
                            let result = CommandTraining(
                                command: commandTraining.command,
                                assignedCommand: assignedCommand
                            )
                            return .just(result)
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
            }
            .map { Route.finished($0) }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeStartTraining() -> Signal<Void> {
        commandTraining
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .never())
    }
    
    func makeCommand() -> Driver<Command> {
        commandTraining
            .map { $0.command }
    }
    
    func makeCommandTraining() -> Driver<CommandTraining> {
        customerCommandId
            .flatMapLatest { [weak self] customerCommandId -> Driver<CommandTraining> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<CommandTraining> {
                    self.commandsManager
                        .obtainCommandTraining(customerCommandId: customerCommandId)
                        .flatMap { commandTraining -> Single<CommandTraining> in
                            guard let commandTraining = commandTraining else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(commandTraining)
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
}
