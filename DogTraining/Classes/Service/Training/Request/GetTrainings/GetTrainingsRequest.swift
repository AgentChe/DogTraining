//
//  GetTrainingsRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import Alamofire

struct GetTrainingsRequest: APIRequestBody {
    let userToken: String
    let levelId: Int?
    
    var url: String {
        GlobalDefinitions.domain + "/api/trainings/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
        
        if let levelId = levelId {
            params["level_id"] = levelId
        }
        
        return params
    }
}
