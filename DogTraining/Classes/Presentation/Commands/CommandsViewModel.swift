//
//  CommandsViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import RxSwift
import RxCocoa

final class CommandsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private let commandGroup: Driver<CommandGroup?>
    private lazy var commands = makeCommands()
    private lazy var commandsGroups = makeCommandsGroups()
    private lazy var profile = makeProfile()
    private lazy var activeSubscription = makeActiveSubscription()
    private lazy var skillLevels = makeSkillLevels()
    
    private lazy var commandsManager = CommandsManager()
    private lazy var sessionManager = SessionManager()
    private lazy var profileManager = ProfileManager()
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(commandGroup: CommandGroup?) {
        self.commandGroup = BehaviorRelay(value: commandGroup).asDriver()
    }
}

// MARK: Private
private extension CommandsViewModel {
    func makeElements() -> Driver<[CommandsTableElement]> {
        Driver
            .combineLatest(commandsGroups, commands, activeSubscription, skillLevels)
            .map { commandsGroups, commands, activeSubscription, skillLevels -> [CommandsTableElement] in
                commands.compactMap { command -> CommandsTableElement? in
                    guard
                        let commandGroup = commandsGroups.first(where: { $0.id == command.commandGroupId }),
                        let skillLevel = skillLevels.first(where: { $0.id == command.skillLevelId })
                    else {
                        return nil
                    }
                    
                    return CommandsTableElement(
                        command: command,
                        commandGroup: commandGroup,
                        skillLevel: skillLevel,
                        locked: command.paid ? !activeSubscription : false
                    )
                }
            }
    }
    
    func makeCommands() -> Driver<[Command]> {
        Driver
            .combineLatest(commandGroup, profile)
            .flatMapLatest { [weak self] commandGroup, profile -> Driver<[Command]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[Command]> {
                    self.commandsManager
                        .obtainCommands(
                            commandGroupId: commandGroup?.id,
                            levelId: profile?.skillLevelId
                        )
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
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeCommandsGroups() -> Driver<[CommandGroup]> {
        commandsManager
            .obtainCommandsGroups(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeProfile() -> Driver<Profile?> {
        profileManager
            .obtainProfile(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { [weak self] in
                guard let self = self else {
                    return false
                }
                
                return self.sessionManager.hasActiveSubscriptions()
            }
            .startWith(sessionManager.hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
