//
//  ProfileEditViewModel.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import RxSwift
import RxCocoa

final class ProfileEditViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    let didSaveSkillLevel = PublishRelay<SkillLevel>()
    let didSaveWeekSchedule = PublishRelay<WeekSchedule>()
    let didSaveCommandsGroups = PublishRelay<[CommandGroup]>()
    let didSaveName = PublishRelay<String>()
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var profileManager = ProfileManager()
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension ProfileEditViewModel {
    struct Input {}
    
    struct Output {
        let saved: Signal<Void>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        Output(
            saved: makeSaveResult(
                didSaveSkillLevel: didSaveSkillLevel.asSignal(),
                didSaveWeekSchedule: didSaveWeekSchedule.asSignal(),
                didSaveCommandsGroups: didSaveCommandsGroups.asSignal(),
                didSaveName: didSaveName.asSignal()
            ),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension ProfileEditViewModel {
    func makeSaveResult(
        didSaveSkillLevel: Signal<SkillLevel>,
        didSaveWeekSchedule: Signal<WeekSchedule>,
        didSaveCommandsGroups: Signal<[CommandGroup]>,
        didSaveName: Signal<String>
    ) -> Signal<Void> {
        let skillLevel = didSaveSkillLevel
            .flatMapLatest { [weak self] skillLevel -> Signal<Void> in
                guard let self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    self.profileManager
                        .set(skillLevelId: skillLevel.id)
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
                    .asSignal(onErrorSignalWith: .never())
            }
        
        let weekSchedule = didSaveWeekSchedule
            .flatMapLatest { [weak self] weekSchedule -> Signal<Void> in
                guard let self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    self.profileManager
                        .set(weekSchedule: weekSchedule)
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
                    .asSignal(onErrorSignalWith: .never())
            }
        
        let commandsGroups = didSaveCommandsGroups
            .flatMapLatest { [weak self] commandsGroups -> Signal<Void> in
                guard let self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    self.profileManager
                        .set(commandGroupIds: commandsGroups.map { $0.id })
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
                    .asSignal(onErrorSignalWith: .never())
            }
        
        let name = didSaveName
            .flatMapLatest { [weak self] name -> Signal<Void> in
                guard let self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    self.profileManager
                        .set(name: name)
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
                    .asSignal(onErrorSignalWith: .never())
            }
        
        return Signal
            .merge(skillLevel, weekSchedule, commandsGroups, name)
    }
}
