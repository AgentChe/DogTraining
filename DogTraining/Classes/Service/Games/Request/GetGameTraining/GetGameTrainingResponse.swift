//
//  GetGameTrainingResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

final class GetGameTrainingResponse {
    static func map(from response: Any) -> GameTraining? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id = data["game_id"] as? Int,
            let skillLevelId = data["level_id"] as? Int,
            let gameGroupId = data["game_group_id"] as? Int,
            let name = data["name"] as? String,
            let imagePath = data["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let explanation = data["short_description"] as? String,
            let instruction = data["long_description"] as? String,
            let customerGameId = data["customer_game_id"] as? Int,
            let finished = data["finished"] as? Bool,
            let trainedTime = data["trained_time"] as? Int
        else {
            return nil
        }
        
        let game = Game(
            id: id,
            skillLevelId: skillLevelId,
            gameGroupId: gameGroupId,
            name: name,
            image: imageUrl,
            paid: data["paid"] as? Bool ?? false,
            explanation: explanation,
            instruction: instruction
        )
        
        var scheduleDate: Date? = nil
        if let scheduleTimestamp = data["schedule_date"] as? TimeInterval {
            scheduleDate = Date(timeIntervalSince1970: scheduleTimestamp)
        }
        
        let assignedGame = AssignedGame(
            customerGameId: customerGameId,
            scheduleDate: scheduleDate,
            finished: finished,
            trainedTime: trainedTime
        )
        
        return GameTraining(
            game: game,
            assignedGame: assignedGame
        )
    }
}
