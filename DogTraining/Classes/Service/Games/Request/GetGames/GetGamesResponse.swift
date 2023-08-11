//
//  GetGamesResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import Foundation

final class GetGamesResponse {
    static func map(from response: Any) -> [Game] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let gamesArray = data["games"] as? [[String: Any]]
        else {
            return []
        }
        
        return gamesArray.compactMap { gameJSON -> Game? in
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
}
