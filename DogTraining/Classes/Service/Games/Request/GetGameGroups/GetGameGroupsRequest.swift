//
//  GetGameGroupsRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

import Alamofire

struct GetGameGroupsRequest: APIRequestBody {
    let userToken: String

    var url: String {
        GlobalDefinitions.domain + "/api/glossary/game_groups"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
    }
}
