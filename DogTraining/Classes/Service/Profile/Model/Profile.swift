//
//  Profile.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

struct Profile: Codable, Hashable {
    let name: String?
    let skillLevelId: Int?
    let weekSchedule: WeekSchedule?
    let commandGroupIds: [Int]?
}
