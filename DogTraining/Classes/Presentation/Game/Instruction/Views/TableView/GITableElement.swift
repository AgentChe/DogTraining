//
//  GITableElement.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import UIKit

enum GITableElement {
    case offset(CGFloat)
    case header(GIHeaderElement)
    case description(GIDescriptionElement)
    case buttons(String)
    case instruction(String)
}

struct GIHeaderElement {
    let image: URL
    let name: String
    let skillLevel: String
    let gameGroup: String
}

struct GIDescriptionElement {
    let description: String
    let isFull: Bool
    
    init(description: String, isFull: Bool) {
        if isFull {
            self.description = description
            self.isFull = isFull
        } else {
            let maxCharacters = 40
            
            if description.count > maxCharacters {
                self.description = String(description.prefix(maxCharacters))
                self.isFull = false
            } else {
                self.description = description
                self.isFull = true
            }
        }
    }
}
