//
//  PlanCommand.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 15.08.2023.
//

import Foundation

struct PlanCommand: Codable, Hashable {
    let customerCommandId: Int
    let name: String
    let image: URL
    let levelId: Int
    let status: PlanStatus
}
