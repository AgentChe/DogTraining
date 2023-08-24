//
//  SetRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 28.08.2022.
//

import Alamofire

struct SetRequest: APIRequestBody {
    let userToken: String
    let skillLevel: Int?
    let weekSchedule: [Int]?
    let commandGroupIds: [Int]?
    let timezone: String?
    let name: String?
    
    var url: String {
        GlobalDefinitions.domain + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
        
        if let skillLevel = skillLevel {
            params["level_id"] = skillLevel
        }
        
        if let weekSchedule = weekSchedule {
            params["training_days"] = weekSchedule
        }
        
        if let commandGroupIds = commandGroupIds {
            params["command_group_ids"] = commandGroupIds
        }
        
        if let timezone = timezone {
            params["timezone"] = timezone
        }
        
        if let name = name {
            params["name"] = name
        }
        
        return params
    }
}
