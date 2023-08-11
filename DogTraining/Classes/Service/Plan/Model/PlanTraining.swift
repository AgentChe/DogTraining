//
//  PlanTraining.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Foundation

struct PlanTraining: Codable, Hashable {
    let customerTrainingId: Int
    let name: String
    let image: URL
    let levelId: Int
    let status: PlanStatus
}
