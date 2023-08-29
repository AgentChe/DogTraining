//
//  EventType.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 26.08.2023.
//

enum EventType: Codable, Hashable, CaseIterable {
    case vaccination
    case antiParasitic
    case medicine
    case symptoms
    case vetVisit
    case care
    case other
}
