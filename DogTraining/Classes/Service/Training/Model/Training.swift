//
//  Training.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

struct Training: Codable, Hashable {
    let id: Int
    let levelId: Int
    let name: String
    let image: URL
    let commands: [Command]
    let commandGroupsIds: [Int]
}
