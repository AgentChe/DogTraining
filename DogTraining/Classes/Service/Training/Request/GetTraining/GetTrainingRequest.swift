//
//  GetTrainingRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct GetTrainingRequest: APIRequestBody {
    let userToken: String
    let customerTrainingId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/trainings/details"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_training_id": customerTrainingId
        ]
    }
}
