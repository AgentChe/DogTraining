//
//  CommandInstructionViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import RxSwift
import RxCocoa

final class CommandInstructionViewModel {
    enum Route {
        case training(customerCommandId: Int)
        case calendar(customerCommandId: Int)
    }
    
    enum Source {
        case command(Command)
        case planCommand(PlanCommand)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTapStartTraining = PublishRelay<Void>()
    lazy var didTapCalendar = PublishRelay<Void>()
    
    lazy var route = makeRoute()
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    lazy var assignActivity = RxActivityIndicator()
    
    private let source: Driver<Source>
    private lazy var command = makeCommand()
    private lazy var commandsGroups = makeCommandsGroups()
    private lazy var skillLevels = makeSkillLevels()
    
    private lazy var commandsManager = CommandsManager()
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(source: Source) {
        self.source = BehaviorRelay(value: source).asDriver()
    }
}

// MARK: Private
private extension CommandInstructionViewModel {
    func makeRoute() -> Driver<Route> {
        let calendarRoute = didTapCalendar
            .withLatestFrom(command)
            .flatMapLatest { [weak self] command -> Driver<Route> in
                guard let self else {
                    return .never()
                }
                
                func source() -> Single<Route> {
                    self.commandsManager
                        .assignCommand(id: command.id)
                        .flatMap { assignedCommand -> Single<Route> in
                            guard let assignedCommand = assignedCommand else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(.calendar(customerCommandId: assignedCommand.customerCommandId))
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
                    .trackActivity(self.assignActivity)
                    .asDriver(onErrorDriveWith: .never())
            }
            .asDriver(onErrorDriveWith: .never())
        
        let trainingRoute = didTapStartTraining
            .withLatestFrom(source)
            .flatMapLatest { [weak self] input -> Driver<Route> in
                guard let self = self else {
                    return .never()
                }
                
                switch input {
                case .command(let command):
                    func source() -> Single<Route> {
                        self.commandsManager
                            .assignCommand(id: command.id)
                            .flatMap { assignedCommand -> Single<Route> in
                                guard let assignedCommand = assignedCommand else {
                                    return .error(ContentError(.notContent))
                                }
                                
                                return .just(.training(customerCommandId: assignedCommand.customerCommandId))
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
                        .trackActivity(self.assignActivity)
                        .asDriver(onErrorDriveWith: .never())
                case .planCommand(let planCommand):
                    return .just(.training(customerCommandId: planCommand.customerCommandId))
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(calendarRoute, trainingRoute)
    }
    
    func makeElements() -> Driver<[GITableElement]> {
        Driver
            .combineLatest(command, commandsGroups, skillLevels)
            .map { command, commandsGroups, skillLevels -> [GITableElement] in
                var result = [GITableElement]()
                
                let headerElement = GIHeaderElement(
                    image: command.image,
                    name: command.name,
                    skillLevel: skillLevels.first(where: { $0.id == command.skillLevelId })?.name ?? "",
                    gameGroup: commandsGroups.first(where: { $0.id == command.commandGroupId })?.name ?? ""
                )
                result.append(.header(headerElement))
                
                result.append(contentsOf: [
                    .offset(16.scale),
                    .buttons("CommandInstruction.StartCommand".localized)
                ])
                
                result.append(contentsOf: [
                    .offset(24.scale),
                    .instruction(command.instruction)
                ])
                
                return result
            }
    }
    
    func makeCommand() -> Driver<Command> {
        source
            .flatMapLatest { [weak self] input -> Driver<Command> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Command> {
                    switch input {
                    case .command(let command):
                        return .just(command)
                    case .planCommand(let planCommand):
                        return self.commandsManager
                            .obtainCommandTraining(customerCommandId: planCommand.customerCommandId)
                            .flatMap { planCommand -> Single<Command> in
                                guard let planCommand = planCommand else {
                                    return .error(ContentError(.notContent))
                                }
                                
                                return .just(planCommand.command)
                            }
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
    
    func makeCommandsGroups() -> Driver<[CommandGroup]> {
        commandsManager
            .obtainCommandsGroups(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
}
