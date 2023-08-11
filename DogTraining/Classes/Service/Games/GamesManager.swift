//
//  GamesManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.03.2023.
//

import RxSwift

protocol GamesManagerProtocol {
    func obtainGameGroups(forceUpdate: Bool) -> Single<[GameGroup]>
    func obtainGames(gameGroupId: Int?, levelId: Int?) -> Single<[Game]>
    func assignGame(id: Int) -> Single<AssignedGame?>
    func scheduleGame(customerGameId: Int, scheduleDate: TimeInterval) -> Single<AssignedGame?>
    func obtainGameTraining(customerGameId: Int) -> Single<GameTraining?>
    func logProgress(customerGameId: Int, trainedTime: Int, finish: Bool) -> Single<AssignedGame?>
}

final class GamesManager {
    enum Constants {
        static let gameGroupsKey = "games_manager_game_groups_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: GamesManagerProtocol
extension GamesManager: GamesManagerProtocol {
    func obtainGameGroups(forceUpdate: Bool) -> Single<[GameGroup]> {
        forceUpdate ? loadGameGroups() : cachedGameGroups()
    }
    
    func obtainGames(gameGroupId: Int?, levelId: Int?) -> Single<[Game]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = GetGamesRequest(
            userToken: userToken,
            gameGroupId: gameGroupId,
            levelId: levelId
        )

        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetGamesResponse.map(from: $0) }
    }
    
    func assignGame(id: Int) -> Single<AssignedGame?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = AssignGameRequest(
            userToken: userToken,
            gameId: id
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { AssignGameResponse.map(from: $0) }
            .do(onSuccess: { assignGame in
                guard let assignGame = assignGame else {
                    return
                }
                
                GamesMediator.shared.didAssign(assignGame)
            })
    }
    
    func scheduleGame(customerGameId: Int, scheduleDate: TimeInterval) -> Single<AssignedGame?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = ScheduleGameRequest(
            userToken: userToken,
            customerGameId: customerGameId,
            scheduleDate: scheduleDate
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { ScheduleGameResponse.map(from: $0) }
            .do(onSuccess: { assignGame in
                guard let assignGame = assignGame else {
                    return
                }
                
                GamesMediator.shared.didSchedule(assignGame)
            })
    }
    
    func obtainGameTraining(customerGameId: Int) -> Single<GameTraining?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetGameTrainingRequest(
            userToken: userToken,
            customerGameId: customerGameId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetGameTrainingResponse.map(from: $0) }
    }
    
    func logProgress(customerGameId: Int, trainedTime: Int, finish: Bool) -> Single<AssignedGame?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = LogGameProgressRequest(
            userToken: userToken,
            customerGameId: customerGameId,
            trainedTime: trainedTime,
            finish: finish
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { LogGameProgressResponse.map(from: $0) }
            .do(onSuccess: { assignGame in
                guard let assignGame = assignGame else {
                    return
                }
                
                GamesMediator.shared.didLogProgress(assignGame)
            })
    }
}

// MARK: Private
private extension GamesManager {
    func loadGameGroups() -> Single<[GameGroup]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetGameGroupsRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetGameGroupsResponse.map(from: $0) }
            .do(onSuccess: { gameGroups in
                guard let data = try? JSONEncoder().encode(gameGroups) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.gameGroupsKey)
            })
    }
    
    func cachedGameGroups() -> Single<[GameGroup]> {
        Single<[GameGroup]>
            .create { event in
                guard let data = UserDefaults.standard.data(forKey: Constants.gameGroupsKey) else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                let gameGroups = try? JSONDecoder().decode([GameGroup].self, from: data)
                
                event(.success(gameGroups ?? []))
                
                return Disposables.create()
            }
    }
}
