//
//  ScheduleCommandRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct ScheduleCommandRequest: APIRequestBody {
    let userToken: String
    let customerCommandId: Int
    let scheduleDate: TimeInterval
    
    var url: String {
        GlobalDefinitions.domain + "/api/commands/schedule"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_command_id": customerCommandId,
            "schedule_date": Int(scheduleDate)
        ]
    }
}
