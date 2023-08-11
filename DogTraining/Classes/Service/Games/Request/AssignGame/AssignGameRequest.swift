//
//  AssignGameRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct AssignGameRequest: APIRequestBody {
    let userToken: String
    let gameId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/games/assign"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "game_id": gameId
        ]
    }
}
