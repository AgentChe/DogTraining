//
//  GetCommandTrainingRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct GetCommandTrainingRequest: APIRequestBody {
    let userToken: String
    let customerCommandId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/commands/details"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "customer_command_id": customerCommandId,
        ]
    }
}
