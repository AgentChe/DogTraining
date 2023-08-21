//
//  ArticleDetails.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 21.08.2023.
//

import Foundation

struct ArticleDetails: Codable, Hashable {
    let id: Int
    let image: URL
    let title: String
    let content: String
}
