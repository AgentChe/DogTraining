//
//  GetGameGroupsResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

final class GetGameGroupsResponse {
    static func map(from response: Any) -> [GameGroup] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let gameGroupsArray = data["game_groups"] as? [[String: Any]]
        else {
            return []
        }
        
        return gameGroupsArray.compactMap { gameGroupJSON -> GameGroup? in
            guard
                let id = gameGroupJSON["game_group_id"] as? Int,
                let name = gameGroupJSON["name"] as? String
            else {
                return nil
            }
            
            return GameGroup(
                id: id,
                name: name
            )
        }
    }
}
