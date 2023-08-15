//
//  HomeTableElement.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit

enum HomeTableElement {
    case offset(CGFloat)
    case title(HomeTitleElement)
    case stats(HomeStatsElement)
    case dailyPicks([DailyPicksElement])
    case plan([PlanWeekDayButton.Model])
    case planTraining(HomePlanTrainingElement)
    case noTrainings
    case addTraining
    case commandsGroups([CommandGroup])
    case tryCommandsTitle(String)
    case command(HomeCommandElement)
    case gamesTitle(String)
    case games([HomeGameElement])
}

enum HomeTitleElement {
    case large(String)
    case small(String)
}

struct HomeStatsElement {
    let score: Int
    let skillLevel: SkillLevel
}

struct DailyPicksElement {
    enum DailyPicks {
        case game(Game)
        case training(Training)
    }
    
    let dailyPicks: DailyPicks
    let image: URL
    let type: String
    let name: String
    let tag1: String
    let tag2: String?
    let action: String
    
    init(game: Game, skillLevel: SkillLevel, gameGroup: GameGroup) {
        dailyPicks = .game(game)
        image = game.image
        type = "Home.Game".localized
        name = game.name
        tag1 = skillLevel.name
        tag2 = gameGroup.name
        action = "Home.StartGame".localized
    }
    
    init(training: Training, skillLevel: SkillLevel) {
        dailyPicks = .training(training)
        image = training.image
        type = "Home.Training".localized
        name = training.name
        tag1 = skillLevel.name
        tag2 = nil
        action = "Home.StartTraining".localized
    }
}

struct HomePlanTrainingElement {
    enum Training {
        case game(PlanGame)
        case training(PlanTraining)
        case command(PlanCommand)
    }
    
    let training: Training
    let skillLevel: SkillLevel
}

struct HomeCommandElement {
    let command: Command
    let commandGroup: CommandGroup
    let skillLevel: SkillLevel
}

struct HomeGameElement {
    let game: Game
    let skillLevel: SkillLevel
}
