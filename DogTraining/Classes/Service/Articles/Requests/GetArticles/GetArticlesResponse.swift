//
//  GetArticlesResponse.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 21.08.2023.
//

import Foundation

enum GetArticlesResponse {
    static func map(from response: Any) -> [Article] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let articlesArray = data["articles"] as? [[String: Any]]
        else {
            return []
        }
        
        return articlesArray.compactMap { articleJSON -> Article? in
            guard
                let id = articleJSON["article_id"] as? Int,
                let imagePath = articleJSON["image"] as? String,
                let image = URL(string: imagePath),
                let title = articleJSON["title"] as? String,
                let paid = articleJSON["paid"] as? Bool
            else {
                return nil
            }
            
            return Article(
                id: id,
                image: image,
                title: title,
                paid: paid
            )
        }
    }
}
