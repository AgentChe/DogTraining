//
//  CommandsManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.03.2023.
//

import RxSwift

protocol CommandsManagerProtocol {
    func obtainCommandsGroups(forceUpdate: Bool) -> Single<[CommandGroup]>
    func obtainCommands(commandGroupId: Int?, levelId: Int?) -> Single<[Command]>
    func assignCommand(id: Int) -> Single<AssignedCommand?>
    func scheduleCommand(customerCommandId: Int, scheduleDate: TimeInterval) -> Single<AssignedCommand?>
    func obtainCommandTraining(customerCommandId: Int) -> Single<CommandTraining?>
    func logProgress(customerCommandId: Int, trainedTime: Int, finish: Bool) -> Single<AssignedCommand?>
}

final class CommandsManager {
    enum Constants {
        static let commandsGroupsKey = "commands_manager_commands_groups_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: CommandsManagerProtocol
extension CommandsManager: CommandsManagerProtocol {
    func obtainCommandsGroups(forceUpdate: Bool) -> Single<[CommandGroup]> {
        forceUpdate ? loadCommandsGroups() : cachedCommandsGroups()
    }
    
    func obtainCommands(commandGroupId: Int?, levelId: Int?) -> Single<[Command]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetCommandsRequest(
            userToken: userToken,
            commandGroupId: commandGroupId,
            levelId: levelId
        )

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetCommandsResponse.map(from: $0) }
    }
    
    func assignCommand(id: Int) -> Single<AssignedCommand?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = AssignCommandRequest(
            userToken: userToken,
            commandId: id
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { AssignCommandResponse.map(from: $0) }
            .do(onSuccess: { assignCommand in
                guard let assignCommand = assignCommand else {
                    return
                }
                
                CommandsMediator.shared.didAssign(assignCommand)
            })
    }
    
    func scheduleCommand(customerCommandId: Int, scheduleDate: TimeInterval) -> Single<AssignedCommand?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = ScheduleCommandRequest(
            userToken: userToken,
            customerCommandId: customerCommandId,
            scheduleDate: scheduleDate
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { ScheduleCommandResponse.map(from: $0) }
            .do(onSuccess: { assignCommand in
                guard let assignCommand = assignCommand else {
                    return
                }
                
                CommandsMediator.shared.didSchedule(assignCommand)
            })
    }
    
    func obtainCommandTraining(customerCommandId: Int) -> Single<CommandTraining?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetCommandTrainingRequest(
            userToken: userToken,
            customerCommandId: customerCommandId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetCommandTrainingResponse.map(from: $0) }
    }
    
    func logProgress(customerCommandId: Int, trainedTime: Int, finish: Bool) -> Single<AssignedCommand?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = LogCommandProgressRequest(
            userToken: userToken,
            customerCommandId: customerCommandId,
            trainedTime: trainedTime,
            finish: finish
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { LogCommandProgressResponse.map(from: $0) }
            .do(onSuccess: { assignCommand in
                guard let assignCommand = assignCommand else {
                    return
                }
                
                CommandsMediator.shared.didLogProgress(assignCommand)
            })
    }
}

// MARK: Private
private extension CommandsManager {
    func loadCommandsGroups() -> Single<[CommandGroup]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetCommandsGroupsRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetCommandsGroupsResponse.map(from: $0) }
            .do(onSuccess: { commandsGroups in
                guard let data = try? JSONEncoder().encode(commandsGroups) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.commandsGroupsKey)
            })
    }
    
    func cachedCommandsGroups() -> Single<[CommandGroup]> {
        Single<[CommandGroup]>
            .create { event in
                guard let data = UserDefaults.standard.data(forKey: Constants.commandsGroupsKey) else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                let commandsGroups = try? JSONDecoder().decode([CommandGroup].self, from: data)
                
                event(.success(commandsGroups ?? []))
                
                return Disposables.create()
            }
    }
}
