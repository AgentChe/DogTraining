//
//  Role.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.02.2023.
//

enum DogOwnerRole: Codable, Hashable {
    case owner, trainer, sitter
}

// MARK: Public
extension DogOwnerRole {
    init?(code: Int) {
        switch code {
        case 0:
            self = .owner
        case 1:
            self = .trainer
        case 2:
            self = .sitter
        default:
            return nil
        }
    }
    
    var code: Int {
        switch self {
        case .owner:
            return 0
        case .trainer:
            return 1
        case .sitter:
            return 2
        }
    }
}
