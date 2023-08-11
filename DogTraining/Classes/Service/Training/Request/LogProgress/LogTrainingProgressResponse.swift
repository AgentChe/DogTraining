//
//  LogTrainingProgressResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

final class LogTrainingProgressResponse {
    static func map(from response: Any) -> AssignedTraining? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let customerTrainingId = data["customer_training_id"] as? Int,
            let finished = data["finished"] as? Bool,
            let trainedTime = data["trained_time"] as? Int
        else {
            return nil
        }
        
        var scheduleDate: Date? = nil
        if let scheduleTimestamp = data["schedule_date"] as? TimeInterval {
            scheduleDate = Date(timeIntervalSince1970: scheduleTimestamp)
        }
        
        return AssignedTraining(
            customerTrainingId: customerTrainingId,
            scheduleDate: scheduleDate,
            finished: finished,
            trainedTime: trainedTime
        )
    }
}
