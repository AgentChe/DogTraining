//
//  TrainingTemplateTableElement.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

enum TrainingTemplateTableElement {
    case offset(CGFloat)
    case header(TrainingTemplateHeaderElement)
    case buttons
    case commandsGroups([CommandGroup])
    case command(Command)
}

struct TrainingTemplateHeaderElement {
    let image: URL
    let name: String
    let skillLevel: String
}
