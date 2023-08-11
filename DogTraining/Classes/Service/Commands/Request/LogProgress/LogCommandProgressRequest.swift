//
//  LogCommandProgressRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct LogCommandProgressRequest: APIRequestBody {
    let userToken: String
    let customerCommandId: Int
    let trainedTime: Int
    let finish: Bool
    
    var url: String {
        GlobalDefinitions.domain + "/api/commands/progress"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_command_id": customerCommandId,
            "trained_time": trainedTime,
            "finish": finish
        ]
    }
}
