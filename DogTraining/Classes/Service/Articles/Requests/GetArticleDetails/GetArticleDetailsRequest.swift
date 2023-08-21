//
//  GetArticleDetailsRequest.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 21.08.2023.
//

import Alamofire

struct GetArticleDetailsRequest: APIRequestBody {
    let userToken: String
    let id: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/articles/details"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "article_id": id
        ]
    }
}
