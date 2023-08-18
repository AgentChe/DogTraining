//
//  GetTrainingsResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import Foundation

final class GetTrainingsResponse {
    static func map(from response: Any) -> [Training] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let trainingsArray = data["trainings"] as? [[String: Any]]
        else {
            return []
        }
        
        return trainingsArray.compactMap { trainingJSON -> Training? in
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
                commandGroupsIds: commandGroupsIds,
                paid: trainingJSON["paid"] as? Bool ?? false
            )
        }
    }
}
