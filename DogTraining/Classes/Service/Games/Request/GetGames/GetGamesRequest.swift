//
//  GetGamesRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import Alamofire

struct GetGamesRequest: APIRequestBody {
    let userToken: String
    let gameGroupId: Int?
    let levelId: Int?
    
    var url: String {
        GlobalDefinitions.domain + "/api/games/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
        
        if let gameGroupId = gameGroupId {
            params["game_group_id"] = gameGroupId
        }
        
        if let levelId = levelId {
            params["level_id"] = levelId
        }
        
        return params
    }
}
