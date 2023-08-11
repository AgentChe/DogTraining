//
//  AssignTrainingRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct AssignTrainingRequest: APIRequestBody {
    let userToken: String
    let trainingId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/trainings/assign"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "training_id": trainingId
        ]
    }
}
