//
//  CommandTemplateInstructionViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 15.03.2023.
//

import RxSwift
import RxCocoa

final class CommandTemplateInstructionViewModel {
    lazy var elements = makeElements()
    
    private let command: Driver<Command>
    
    init(command: Command) {
        self.command = BehaviorRelay(value: command).asDriver()
    }
}

// MARK: Private
private extension CommandTemplateInstructionViewModel {
    func makeElements() -> Driver<[CommandInstructionTableElement]> {
        command
            .map { command -> [CommandInstructionTableElement] in
                [
                    .image(command.image),
                    .offset(16.scale),
                    .name(command.name),
                    .offset(24.scale),
                    .instruction(command.instruction)
                ]
            }
    }
}
