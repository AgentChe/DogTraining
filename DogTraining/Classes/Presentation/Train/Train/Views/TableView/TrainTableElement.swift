//
//  TrainTableElement.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.03.2023.
//

import Foundation

struct TrainTableSection {
    let elements: [TrainTableElement]
}

enum TrainTableElement {
    case title(TrainTitleElement)
    case trainings([TrainTrainigElement])
    case article(Article)
}

enum TrainTitleElement {
    case trainings(String)
    case commands(String)
    case gamesGroup(GameGroup)
}

struct TrainTrainigElement {
    enum Element {
        case game(Game)
        case training(Training)
        case command(Command)
    }
    
    let element: Element
    let image: URL
    let name: String
    let tag1: String
    let tag2: String?
}
