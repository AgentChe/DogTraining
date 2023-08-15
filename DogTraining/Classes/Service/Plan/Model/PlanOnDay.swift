//
//  PlanOnDay.swift
//  Soccer
//
//  Created by Андрей Чернышев on 08.03.2023.
//

import Foundation

struct PlanOnDay: Codable, Hashable {
    let day: Date
    let status: PlanStatus
    let games: [PlanGame]
    let trainings: [PlanTraining]
    let commands: [PlanCommand]
}
