//
//  GetArticlesRequest.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 21.08.2023.
//

import Alamofire

struct GetArticlesRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/articles/list"
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
