//
//  GetPlanResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Foundation

final class GetPlanResponse {
    static func map(from response: Any) -> [PlanOnDay] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let plan = data["plan"] as? [String: [String: Any]]
        else {
            return []
        }
        
        return map(planJSON: plan)
    }
    
    static func map(planJSON: [String: [String: Any]]) -> [PlanOnDay] {
        planJSON.compactMap { day, planJSON -> PlanOnDay? in
            guard
                let day = TimeInterval(day),
                let statusCode = planJSON["status"] as? Int,
                let status = Self.status(from: statusCode)
            else {
                return nil
            }
            
            let gamesArray = planJSON["games"] as? [[String: Any]]
            let trainingsArray = planJSON["trainings"] as? [[String: Any]]
            let commandsArray = planJSON["commands"] as? [[String: Any]]
            
            let games = (gamesArray ?? []).compactMap { gameJSON -> PlanGame? in
                guard
                    let customerGameId = gameJSON["customer_game_id"] as? Int,
                    let name = gameJSON["name"] as? String,
                    let imagePath = gameJSON["image"] as? String,
                    let imageUrl = URL(string: imagePath),
                    let levelId = gameJSON["level_id"] as? Int,
                    let statusCode = gameJSON["status"] as? Int,
                    let status = Self.status(from: statusCode),
                    let gameGroupId = gameJSON["game_group_id"] as? Int
                else {
                    return nil
                }
                
                return PlanGame(
                    customerGameId: customerGameId,
                    gameGroupId: gameGroupId,
                    name: name,
                    image: imageUrl,
                    levelId: levelId,
                    status: status
                )
            }
            
            let trainings = (trainingsArray ?? []).compactMap { trainingJSON -> PlanTraining? in
                guard
                    let customerTrainingId = trainingJSON["customer_training_id"] as? Int,
                    let name = trainingJSON["name"] as? String,
                    let imagePath = trainingJSON["image"] as? String,
                    let imageUrl = URL(string: imagePath),
                    let levelId = trainingJSON["level_id"] as? Int,
                    let statusCode = trainingJSON["status"] as? Int,
                    let status = Self.status(from: statusCode)
                else {
                    return nil
                }
                
                return PlanTraining(
                    customerTrainingId: customerTrainingId,
                    name: name,
                    image: imageUrl,
                    levelId: levelId,
                    status: status
                )
            }
            
            let commands = (commandsArray ?? []).compactMap { commandJSON -> PlanCommand? in
                guard
                    let customerCommandId = commandJSON["customer_command_id"] as? Int,
                    let name = commandJSON["name"] as? String,
                    let imagePath = commandJSON["image"] as? String,
                    let imageUrl = URL(string: imagePath),
                    let levelId = commandJSON["level_id"] as? Int,
                    let statusCode = commandJSON["status"] as? Int,
                    let status = Self.status(from: statusCode)
                else {
                    return nil
                }
                
                return PlanCommand(
                    customerCommandId: customerCommandId,
                    name: name,
                    image: imageUrl,
                    levelId: levelId,
                    status: status
                )
            }
            
            return PlanOnDay(
                day: Date(timeIntervalSince1970: day),
                status: status,
                games: games,
                trainings: trainings,
                commands: commands
            )
        }
    }
}

// MARK: Private
private extension GetPlanResponse {
    static func status(from code: Int) -> PlanStatus? {
        switch code {
        case -1:
            return .skipped
        case 0:
            return .planned
        case 1:
            return .completed
        default:
            return nil
        }
    }
}
