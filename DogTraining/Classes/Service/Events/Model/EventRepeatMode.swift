//
//  EventRepeatMode.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 26.08.2023.
//

enum EventRepeatMode: Codable, Hashable, CaseIterable {
    case never
    case daily
    case weekly
    case monthly
    case yearly
}

// MARK: Public
extension EventRepeatMode {
    var title: String {
        switch self {
        case .never:
            return "RepeatMode.Never".localized
        case .daily:
            return "RepeatMode.Daily".localized
        case .weekly:
            return "RepeatMode.Weekly".localized
        case .monthly:
            return "RepeatMode.Monthly".localized
        case .yearly:
            return "RepeatMode.Yearly".localized
        }
    }
}
