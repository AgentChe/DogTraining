//
//  LogGameProgressRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct LogGameProgressRequest: APIRequestBody {
    let userToken: String
    let customerGameId: Int
    let trainedTime: Int
    let finish: Bool
    
    var url: String {
        GlobalDefinitions.domain + "/api/games/progress"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_game_id": customerGameId,
            "trained_time": trainedTime,
            "finish": finish
        ]
    }
}
