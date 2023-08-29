//
//  EventsOnDay.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 29.08.2023.
//

import Foundation

struct EventsOnDay: Codable, Hashable {
    let day: Date
    let events: [Event]
}
