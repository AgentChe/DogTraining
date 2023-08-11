//
//  AssignedCommand.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

struct AssignedCommand: Codable, Hashable {
    let customerCommandId: Int
    let scheduleDate: Date?
    let finished: Bool
    let trainedTime: Int
}
