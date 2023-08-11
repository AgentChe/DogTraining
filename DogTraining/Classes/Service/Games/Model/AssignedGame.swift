//
//  AssignedGame.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

struct AssignedGame: Codable, Hashable {
    let customerGameId: Int
    let scheduleDate: Date?
    let finished: Bool
    let trainedTime: Int
}
