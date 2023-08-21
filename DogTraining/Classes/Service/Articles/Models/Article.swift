//
//  Article.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 21.08.2023.
//

import Foundation

struct Article: Codable, Hashable {
    let id: Int
    let image: URL
    let title: String
    let paid: Bool
}
