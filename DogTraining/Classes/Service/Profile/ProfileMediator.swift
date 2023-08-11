//
//  ProfileMediator.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

import RxSwift
import RxCocoa

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private lazy var skillLevelIdChangeTrigger = PublishRelay<Int>()
    private lazy var weekScheduleChangeTrigger = PublishRelay<WeekSchedule>()
    private lazy var commandGroupIdsChangeTrigger = PublishRelay<[Int]>()
    
    private init() {}
}

// MARK: Public
extension ProfileMediator {
    func notify(skillLevelId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.skillLevelIdChangeTrigger.accept(skillLevelId)
        }
    }
    
    func notify(weekSchedule: WeekSchedule) {
        DispatchQueue.main.async { [weak self] in
            self?.weekScheduleChangeTrigger.accept(weekSchedule)
        }
    }
    
    func notify(commandGroupIds: [Int]) {
        DispatchQueue.main.async { [weak self] in
            self?.commandGroupIdsChangeTrigger.accept(commandGroupIds)
        }
    }
}

// MARK: Public (Rx)
extension ProfileMediator {
    var skillLevelIdChange: Signal<Int> {
        skillLevelIdChangeTrigger.asSignal()
    }
    
    var weekScheduleChange: Signal<WeekSchedule> {
        weekScheduleChangeTrigger.asSignal()
    }
    
    var commandGroupIdsChange: Signal<[Int]> {
        commandGroupIdsChangeTrigger.asSignal()
    }
}
