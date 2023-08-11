//
//  GetGameTrainingRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct GetGameTrainingRequest: APIRequestBody {
    let userToken: String
    let customerGameId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/games/details"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_game_id": customerGameId,
        ]
    }
}
