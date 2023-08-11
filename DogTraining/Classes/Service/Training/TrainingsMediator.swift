//
//  TrainingsMediator.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.03.2023.
//

import RxSwift
import RxCocoa

final class TrainingsMediator {
    static let shared = TrainingsMediator()
    
    private lazy var didLogProgressTrigger = PublishRelay<AssignedTraining>()
    private lazy var didScheduleTrigger = PublishRelay<AssignedTraining>()
    private lazy var didAssignTrigger = PublishRelay<AssignedTraining>()
    
    private init() {}
}

// MARK: Public
extension TrainingsMediator {
    func didLogProgress(_ assignedTraining: AssignedTraining) {
        DispatchQueue.main.async {
            Self.shared.didLogProgressTrigger.accept(assignedTraining)
        }
    }
    
    func didSchedule(_ assignedTraining: AssignedTraining) {
        DispatchQueue.main.async {
            Self.shared.didScheduleTrigger.accept(assignedTraining)
        }
    }
    
    func didAssign(_ assignedTraining: AssignedTraining) {
        DispatchQueue.main.async {
            Self.shared.didAssignTrigger.accept(assignedTraining)
        }
    }
    
    var didLogProgress: Signal<AssignedTraining> {
        didLogProgressTrigger.asSignal()
    }
    
    var didSchedule: Signal<AssignedTraining> {
        didScheduleTrigger.asSignal()
    }
    
    var didAssign: Signal<AssignedTraining> {
        didAssignTrigger.asSignal()
    }
}
