//
//  LogTrainingProgressRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct LogTrainingProgressRequest: APIRequestBody {
    let userToken: String
    let customerTrainingId: Int
    let trainedTime: Int
    let finish: Bool
    let commandId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/trainings/progress"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_training_id": customerTrainingId,
            "trained_time": trainedTime,
            "command_id": commandId,
            "finish_workout": finish
        ]
    }
}
