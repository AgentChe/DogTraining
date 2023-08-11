//
//  CommandsMediator.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.03.2023.
//

import RxSwift
import RxCocoa

final class CommandsMediator {
    static let shared = CommandsMediator()
    
    private lazy var didLogProgressTrigger = PublishRelay<AssignedCommand>()
    private lazy var didScheduleTrigger = PublishRelay<AssignedCommand>()
    private lazy var didAssignTrigger = PublishRelay<AssignedCommand>()
    
    private init() {}
}

// MARK: Public
extension CommandsMediator {
    func didLogProgress(_ assignedCommand: AssignedCommand) {
        DispatchQueue.main.async {
            Self.shared.didLogProgressTrigger.accept(assignedCommand)
        }
    }
    
    func didSchedule(_ assignedCommand: AssignedCommand) {
        DispatchQueue.main.async {
            Self.shared.didScheduleTrigger.accept(assignedCommand)
        }
    }
    
    func didAssign(_ assignedCommand: AssignedCommand) {
        DispatchQueue.main.async {
            Self.shared.didAssignTrigger.accept(assignedCommand)
        }
    }
    
    var didLogProgress: Signal<AssignedCommand> {
        didLogProgressTrigger.asSignal()
    }
    
    var didSchedule: Signal<AssignedCommand> {
        didScheduleTrigger.asSignal()
    }
    
    var didAssign: Signal<AssignedCommand> {
        didAssignTrigger.asSignal()
    }
}
