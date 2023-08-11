//
//  GetCommandTrainingResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

final class GetCommandTrainingResponse {
    static func map(from response: Any) -> CommandTraining? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id = data["command_id"] as? Int,
            let name = data["name"] as? String,
            let skillLevelId = data["level_id"] as? Int,
            let imagePath = data["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let commandGroupId = data["customer_command_id"] as? Int,
            let instruction = data["description"] as? String,
            let customerCommandId = data["customer_command_id"] as? Int,
            let finished = data["finished"] as? Bool,
            let trainedTime = data["trained_time"] as? Int
        else {
            return nil
        }
        
        let paid = data["paid"] as? Bool
        
        let command = Command(
            id: id,
            skillLevelId: skillLevelId,
            commandGroupId: commandGroupId,
            name: name,
            image: imageUrl,
            paid: data["paid"] as? Bool ?? false,
            instruction: instruction
        )
        
        var scheduleDate: Date? = nil
        if let scheduleTimestamp = data["schedule_date"] as? TimeInterval {
            scheduleDate = Date(timeIntervalSince1970: scheduleTimestamp)
        }
        
        let assignedCommand = AssignedCommand(
            customerCommandId: customerCommandId,
            scheduleDate: scheduleDate,
            finished: finished,
            trainedTime: trainedTime
        )
        
        return CommandTraining(
            command: command,
            assignedCommand: assignedCommand
        )
    }
}
