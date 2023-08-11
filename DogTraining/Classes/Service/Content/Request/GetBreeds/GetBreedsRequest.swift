//
//  GetBreedsRequest.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 11.08.2023.
//

import Alamofire

struct GetBreedsRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/glossary/breeds"
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
