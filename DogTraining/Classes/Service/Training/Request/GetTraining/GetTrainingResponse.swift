//
//  GetTrainingResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

final class GetTrainingResponse {
    static func map(from response: Any) -> TrainigDetails? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id = data["training_id"] as? Int,
            let name = data["name"] as? String,
            let skillLevelId = data["level_id"] as? Int,
            let imagePath = data["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let commandsArray = data["commands"] as? [[String: Any]],
            let customerTrainingId = data["customer_training_id"] as? Int,
            let finished = data["finished"] as? Bool,
            let trainedTime = data["trained_time"] as? Int,
            let commandGroupIds = data["command_group_ids"] as? [Int]
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
        
        let training = Training(
            id: id,
            levelId: skillLevelId,
            name: name,
            image: imageUrl,
            commands: commands,
            commandGroupsIds: commandGroupIds
        )
        
        var scheduleDate: Date? = nil
        if let scheduleTimestamp = data["schedule_date"] as? TimeInterval {
            scheduleDate = Date(timeIntervalSince1970: scheduleTimestamp)
        }
        
        let assignedTraining = AssignedTraining(
            customerTrainingId: customerTrainingId,
            scheduleDate: scheduleDate,
            finished: finished,
            trainedTime: trainedTime
        )
        
        return TrainigDetails(
            training: training,
            assignedTraining: assignedTraining
        )
    }
}
