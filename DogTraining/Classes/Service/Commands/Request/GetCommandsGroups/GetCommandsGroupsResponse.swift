//
//  GetCommandsGroupsResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

final class GetCommandsGroupsResponse {
    static func map(from response: Any) -> [CommandGroup] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let commandGroupsArray = data["command_groups"] as? [[String: Any]]
        else {
            return []
        }
        
        return commandGroupsArray.compactMap { commandGroupJSON -> CommandGroup? in
            guard
                let id = commandGroupJSON["command_group_id"] as? Int,
                let name = commandGroupJSON["name"] as? String
            else {
                return nil
            }
            
            return CommandGroup(
                id: id,
                name: name
            )
        }
    }
}
