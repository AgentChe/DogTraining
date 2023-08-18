//
//  TrainingsManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.03.2023.
//

import RxSwift

protocol TrainingsManagerProtocol {
    func obtainTrainings(levelId: Int?) -> Single<[Training]>
    func assignTraining(id: Int) -> Single<AssignedTraining?>
    func scheduleTraining(customerTrainingId: Int, scheduleDate: TimeInterval) -> Single<AssignedTraining?>
    func obtainTrainingDetails(customerTrainingId: Int) -> Single<TrainingDetails?>
    func logProgress(customerTrainingId: Int, trainedTime: Int, finish: Bool, commandId: Int) -> Single<AssignedTraining?>
}

final class TrainingsManager {
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: TrainingsManagerProtocol
extension TrainingsManager: TrainingsManagerProtocol {
    func obtainTrainings(levelId: Int?) -> Single<[Training]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetTrainingsRequest(
            userToken: userToken,
            levelId: levelId
        )

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetTrainingsResponse.map(from: $0) }
    }
    
    func assignTraining(id: Int) -> Single<AssignedTraining?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = AssignTrainingRequest(
            userToken: userToken,
            trainingId: id
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { AssignTrainingResponse.map(from: $0) }
            .do(onSuccess: { assignTraining in
                guard let assignTraining = assignTraining else {
                    return
                }
                
                TrainingsMediator.shared.didAssign(assignTraining)
            })
    }
    
    func scheduleTraining(customerTrainingId: Int, scheduleDate: TimeInterval) -> Single<AssignedTraining?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = ScheduleTrainingRequest(
            userToken: userToken,
            customerTrainingId: customerTrainingId,
            scheduleDate: scheduleDate
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { ScheduleTrainingResponse.map(from: $0) }
            .do(onSuccess: { assignTraining in
                guard let assignTraining = assignTraining else {
                    return
                }
                
                TrainingsMediator.shared.didSchedule(assignTraining)
            })
    }
    
    func obtainTrainingDetails(customerTrainingId: Int) -> Single<TrainingDetails?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetTrainingRequest(
            userToken: userToken,
            customerTrainingId: customerTrainingId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetTrainingResponse.map(from: $0) }
    }
    
    func logProgress(customerTrainingId: Int, trainedTime: Int, finish: Bool, commandId: Int) -> Single<AssignedTraining?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = LogTrainingProgressRequest(
            userToken: userToken,
            customerTrainingId: customerTrainingId,
            trainedTime: trainedTime,
            finish: finish,
            commandId: commandId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { LogTrainingProgressResponse.map(from: $0) }
            .do(onSuccess: { assignTraining in
                guard let assignTraining = assignTraining else {
                    return
                }
                
                TrainingsMediator.shared.didLogProgress(assignTraining)
            })
    }
}
