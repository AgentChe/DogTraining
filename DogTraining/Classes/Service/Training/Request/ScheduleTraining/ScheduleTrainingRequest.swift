//
//  ScheduleTrainingRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct ScheduleTrainingRequest: APIRequestBody {
    let userToken: String
    let customerTrainingId: Int
    let scheduleDate: TimeInterval
    
    var url: String {
        GlobalDefinitions.domain + "/api/trainings/schedule"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_training_id": customerTrainingId,
            "schedule_date": Int(scheduleDate)
        ]
    }
}
