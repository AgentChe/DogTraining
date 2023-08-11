//
//  AssignCommandResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

final class AssignCommandResponse {
    static func map(from response: Any) -> AssignedCommand? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let customerCommandId = data["customer_command_id"] as? Int,
            let finished = data["finished"] as? Bool
        else {
            return nil
        }
        
        var scheduleDate: Date? = nil
        if let scheduleTimestamp = data["schedule_date"] as? TimeInterval {
            scheduleDate = Date(timeIntervalSince1970: scheduleTimestamp)
        }
        
        let trainedTime = data["trained_time"] as? Int
        
        return AssignedCommand(
            customerCommandId: customerCommandId,
            scheduleDate: scheduleDate,
            finished: finished,
            trainedTime: trainedTime ?? 0
        )
    }
}
