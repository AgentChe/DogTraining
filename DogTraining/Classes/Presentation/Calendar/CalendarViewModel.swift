//
//  CalendarViewModel.swift
//  Soccer
//
//  Created by Виталий Загороднов on 21.04.2023.
//

import RxSwift
import RxCocoa

final class CalendarViewModel {
    enum SchedulerType {
        case game(customerGameId: Int)
        case command(customerCommandId: Int)
        case training(customerTrainingId: Int)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    lazy var didTapAdd = PublishRelay<Void>()
    lazy var selectedDate = BehaviorRelay<Date?>(value: nil)
    
    lazy var activity = RxActivityIndicator()
    lazy var plan = makePlan()
    lazy var scheduleResult = makeAddScheduleResult()
    
    private let schedulerType: SchedulerType
    
    init(schedulerType: SchedulerType) {
        self.schedulerType = schedulerType
    }
    
    private lazy var planManager = PlanManager()
    private lazy var gamesManager = GamesManager()
    private lazy var commandsManager = CommandsManager()
    private lazy var trainingsManager = TrainingsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension CalendarViewModel {
    func makePlan() -> Driver<[PlanOnDay]> {
        func source() -> Single<[PlanOnDay]> {
            planManager.obtainPlan()
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        return self.observableRetrySingle
            .retry(source: source, trigger: trigger)
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeAddScheduleResult() -> Signal<Void> {
        didTapAdd
            .withLatestFrom(selectedDate.compactMap { $0 })
            .flatMapLatest { [weak self] date -> Observable<Void> in
                guard let self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    switch self.schedulerType {
                    case let .game(customerGameId):
                        return self.gamesManager.scheduleGame(customerGameId: customerGameId, scheduleDate: date.timeIntervalSince1970)
                            .mapToVoid()
                    case let .command(customerCommandId):
                        return self.commandsManager.scheduleCommand(customerCommandId: customerCommandId, scheduleDate: date.timeIntervalSince1970)
                            .mapToVoid()
                    case let .training(customerTrainingId):
                        return self.trainingsManager.scheduleTraining(customerTrainingId: customerTrainingId, scheduleDate: date.timeIntervalSince1970)
                            .mapToVoid()
                    }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: source, trigger: trigger)
                    .trackActivity(self.activity)
            }
            .asSignal(onErrorSignalWith: .never())
    }
}
