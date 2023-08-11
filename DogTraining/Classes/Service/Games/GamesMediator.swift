//
//  GamesMediator.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.03.2023.
//

import RxSwift
import RxCocoa

final class GamesMediator {
    static let shared = GamesMediator()
    
    private lazy var didLogProgressTrigger = PublishRelay<AssignedGame>()
    private lazy var didScheduleTrigger = PublishRelay<AssignedGame>()
    private lazy var didAssignTrigger = PublishRelay<AssignedGame>()
    
    private init() {}
}

// MARK: Public
extension GamesMediator {
    func didLogProgress(_ assignedGame: AssignedGame) {
        DispatchQueue.main.async {
            Self.shared.didLogProgressTrigger.accept(assignedGame)
        }
    }
    
    func didSchedule(_ assignedGame: AssignedGame) {
        DispatchQueue.main.async {
            Self.shared.didScheduleTrigger.accept(assignedGame)
        }
    }
    
    func didAssign(_ assignedGame: AssignedGame) {
        DispatchQueue.main.async {
            Self.shared.didAssignTrigger.accept(assignedGame)
        }
    }
    
    var didLogProgress: Signal<AssignedGame> {
        didLogProgressTrigger.asSignal()
    }
    
    var didSchedule: Signal<AssignedGame> {
        didScheduleTrigger.asSignal()
    }
    
    var didAssign: Signal<AssignedGame> {
        didAssignTrigger.asSignal()
    }
}
