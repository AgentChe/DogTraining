//
//  ProfileTableElement.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import Foundation

enum ProfileTableElement {
    case settings(String)
    case progress(percent: Int, level: String)
    case calendar
    case event(ProfileEventElement)
    case addEvent
    case stats(commands: String, trainings: String, games: String)
}

struct ProfileEventElement {
    let event: Event
    let date: Date
}
