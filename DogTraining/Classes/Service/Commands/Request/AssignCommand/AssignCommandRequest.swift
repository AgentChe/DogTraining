//
//  AssignCommandRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Alamofire

struct AssignCommandRequest: APIRequestBody {
    let userToken: String
    let commandId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/commands/assign"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "command_id": commandId
        ]
    }
}
