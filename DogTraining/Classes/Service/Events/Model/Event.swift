//
//  Event.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 26.08.2023.
//

import Foundation

struct Event: Codable, Hashable {
    let id: String
    let type: EventType
    let note: String
    let date: Date
    let repeatMode: EventRepeatMode
}
