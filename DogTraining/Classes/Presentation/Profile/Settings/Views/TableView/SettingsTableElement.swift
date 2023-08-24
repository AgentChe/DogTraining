//
//  SettingsTableElement.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import Foundation

enum SettingsTableElement {
    case item(type: CellType, isLast: Bool = false, subtitle: String? = nil)
    case header(String)
    
    enum CellType {
        case skillLevel
        case trainingDays
        case commandsGroups
        case dogName
        case termsOfUse
        case privatePolicy
        case contactUs
    }
}
