//
//  GetCommandsResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import Foundation

final class GetCommandsResponse {
    static func map(from response: Any) -> [Command] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let commandsArray = data["commands"] as? [[String: Any]]
        else {
            return []
        }
        
        return commandsArray.compactMap { commandJSON -> Command? in
            guard
                let id = commandJSON["command_id"] as? Int,
                let name = commandJSON["name"] as? String,
                let skillLevelId = commandJSON["level_id"] as? Int,
                let imagePath = commandJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let commandGroupId = commandJSON["command_group_id"] as? Int,
                let instruction = commandJSON["description"] as? String
            else {
                return nil
            }
            
            return Command(
                id: id,
                skillLevelId: skillLevelId,
                commandGroupId: commandGroupId,
                name: name,
                image: imageUrl,
                paid: data["paid"] as? Bool ?? false,
                instruction: instruction
            )
        }
    }
}
