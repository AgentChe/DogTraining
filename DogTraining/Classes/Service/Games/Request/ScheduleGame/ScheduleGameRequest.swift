//
//  ScheduleGameRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct ScheduleGameRequest: APIRequestBody {
    let userToken: String
    let customerGameId: Int
    let scheduleDate: TimeInterval
    
    var url: String {
        GlobalDefinitions.domain + "/api/games/schedule"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_game_id": customerGameId,
            "schedule_date": Int(scheduleDate)
        ]
    }
}
