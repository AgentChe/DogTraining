//
//  Home.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 11.08.2023.
//

struct HomeKit: Codable, Hashable {
    let score: Int
    let levelId: Int
    let dailyGames: [Game]
    let dailyTrainings: [Training]
    let plan: [PlanOnDay]
    let tryGames: [Game]
}
