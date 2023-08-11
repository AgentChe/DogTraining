//
//  AssignedTraining.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.03.2023.
//

import Foundation

struct AssignedTraining: Codable, Hashable {
    let customerTrainingId: Int
    let scheduleDate: Date?
    let finished: Bool
    let trainedTime: Int
}
