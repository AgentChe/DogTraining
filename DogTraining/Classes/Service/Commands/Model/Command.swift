//
//  Command.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

struct Command: Codable, Hashable {
    let id: Int
    let skillLevelId: Int
    let commandGroupId: Int
    let name: String
    let image: URL
    let paid: Bool
    let explanation: String
}
