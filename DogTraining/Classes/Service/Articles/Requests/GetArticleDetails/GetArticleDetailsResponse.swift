//
//  GetArticleDetailsResponse.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 21.08.2023.
//

import Foundation

enum GetArticleDetailsResponse {
    static func map(from response: Any) -> ArticleDetails? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id = data["article_id"] as? Int,
            let imagePath = data["image"] as? String,
            let image = URL(string: imagePath),
            let title = data["title"] as? String,
            let content = data["content"] as? String
        else {
            return nil
        }
        
        return ArticleDetails(
            id: id,
            image: image,
            title: title,
            content: content
        )
    }
}
