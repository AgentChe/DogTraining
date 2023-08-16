//
//  CommandTrainingResultViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import RxSwift
import RxCocoa

final class CommandTrainingResultViewModel {
    lazy var skillLevel = makeSkillLevel()
    lazy var commandGroup = makeCommandGroup()
    
    private let commandTraining: Driver<CommandTraining>
    
    private lazy var commandsManager = CommandsManager()
    private lazy var contentManager = ContentManager()
    
    init(commandTraining: CommandTraining) {
        self.commandTraining = BehaviorRelay(value: commandTraining).asDriver()
    }
}

// MARK: Public
extension CommandTrainingResultViewModel {
    func makeSkillLevel() -> Driver<SkillLevel> {
        commandTraining
            .flatMapLatest { [weak self] commandTraining -> Driver<SkillLevel> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainLevels(forceUpdate: false)
                    .compactMap { skillLevels -> SkillLevel? in
                        skillLevels.first(where: { $0.id == commandTraining.command.skillLevelId })
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeCommandGroup() -> Driver<CommandGroup> {
        commandTraining
            .flatMapLatest { [weak self] commandTraining -> Driver<CommandGroup> in
                guard let self = self else {
                    return .never()
                }
                
                return self.commandsManager
                    .obtainCommandsGroups(forceUpdate: false)
                    .compactMap { commandsGroups -> CommandGroup? in
                        commandsGroups.first(where: { $0.id == commandTraining.command.commandGroupId })
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
