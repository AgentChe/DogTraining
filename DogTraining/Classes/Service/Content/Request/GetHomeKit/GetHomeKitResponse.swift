//
//  GetHomeKitResponse.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 11.08.2023.
//

import Foundation

final class GetHomeKitResponse {
    static func map(from response: Any) -> HomeKit? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let score = data["score"] as? Int,
            let levelId = data["level_id"] as? Int,
            let dailyPicks = data["daily_picks"] as? [String: Any],
            let dailyGamesArray = dailyPicks["games"] as? [[String: Any]],
            let dailyTrainingsArray = dailyPicks["trainings"] as? [[String: Any]],
            let tryCommandsArray = data["try_commands"] as? [[String: Any]],
            let gamesArray = data["games"] as? [[String: Any]]
        else {
            return nil
        }
        
        let planJSON = data["plan"] as? [String: [String: Any]]
        
        let dailyGames = map(gamesArray: dailyGamesArray)
        let dailyTrainings = map(trainingsArray: dailyTrainingsArray)
        let plan = GetPlanResponse.map(planJSON: planJSON ?? [:])
        let tryCommands = map(commandsArray: tryCommandsArray)
        let games = map(gamesArray: gamesArray)
        
        return HomeKit(
            score: score,
            levelId: levelId,
            dailyGames: dailyGames,
            dailyTrainings: dailyTrainings,
            plan: plan,
            tryCommands: tryCommands,
            games: games
        )
    }
}

// MARK: Private
private extension GetHomeKitResponse {
    static func map(gamesArray: [[String: Any]]) -> [Game] {
        gamesArray.compactMap { gameJSON -> Game? in
            guard
                let id = gameJSON["game_id"] as? Int,
                let skillLevelId = gameJSON["level_id"] as? Int,
                let gameGroupId = gameJSON["game_group_id"] as? Int,
                let name = gameJSON["name"] as? String,
                let imagePath = gameJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let explanation = gameJSON["short_description"] as? String,
                let instruction = gameJSON["long_description"] as? String
            else {
                return nil
            }
            
            return Game(
                id: id,
                skillLevelId: skillLevelId,
                gameGroupId: gameGroupId,
                name: name,
                image: imageUrl,
                paid: gameJSON["paid"] as? Bool ?? false,
                explanation: explanation,
                instruction: instruction
            )
        }
    }
    
    static func map(trainingsArray: [[String: Any]]) -> [Training] {
        trainingsArray.compactMap { trainingJSON -> Training? in
            guard
                let id = trainingJSON["training_id"] as? Int,
                let name = trainingJSON["name"] as? String,
                let skillLevelId = trainingJSON["level_id"] as? Int,
                let imagePath = trainingJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let commandsArray = trainingJSON["commands"] as? [[String: Any]],
                let commandGroupsIds = trainingJSON["command_group_ids"] as? [Int]
            else {
                return nil
            }
            
            let commands = commandsArray.compactMap { commandJSON -> Command? in
                guard
                    let id = commandJSON["command_id"] as? Int,
                    let name = commandJSON["name"] as? String,
                    let skillLevelId = commandJSON["level_id"] as? Int,
                    let imagePath = commandJSON["image"] as? String,
                    let imageUrl = URL(string: imagePath),
                    let commandGroupId = commandJSON["command_group_id"] as? Int,
                    let instruction = commandJSON["description"] as? String,
                    let time = commandJSON["time"] as? Int
                else {
                    return nil
                }
                
                return Command(
                    id: id,
                    skillLevelId: skillLevelId,
                    commandGroupId: commandGroupId,
                    name: name,
                    image: imageUrl,
                    paid: commandJSON["paid"] as? Bool ?? false,
                    instruction: instruction,
                    time: time
                )
            }
            
            return Training(
                id: id,
                levelId: skillLevelId,
                name: name,
                image: imageUrl,
                commands: commands,
                commandGroupsIds: commandGroupsIds
            )
        }
    }
    
    static func map(commandsArray: [[String: Any]]) -> [Command] {
        commandsArray.compactMap { commandJSON -> Command? in
            guard
                let id = commandJSON["command_id"] as? Int,
                let name = commandJSON["name"] as? String,
                let skillLevelId = commandJSON["level_id"] as? Int,
                let imagePath = commandJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let commandGroupId = commandJSON["command_group_id"] as? Int,
                let instruction = commandJSON["description"] as? String,
                let time = commandJSON["time"] as? Int
            else {
                return nil
            }
            
            return Command(
                id: id,
                skillLevelId: skillLevelId,
                commandGroupId: commandGroupId,
                name: name,
                image: imageUrl,
                paid: commandJSON["paid"] as? Bool ?? false,
                instruction: instruction,
                time: time
            )
        }
    }
}
