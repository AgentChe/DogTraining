//
//  PlanGame.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Foundation

struct PlanGame: Codable, Hashable {
    let customerGameId: Int
    let gameGroupId: Int
    let name: String
    let image: URL
    let levelId: Int
    let status: PlanStatus
}
