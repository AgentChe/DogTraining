//
//  EventsNotificationsManager.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 29.08.2023.
//

import UserNotifications
import RxSwift
import RxCocoa

final class EventsNotificationsManager {
    static let shared = EventsNotificationsManager()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var center = UNUserNotificationCenter.current()
    
    private init() {}
}

// MARK: Public
extension EventsNotificationsManager {
    func register() {
        EventsMediator.shared.didAdd
            .emit(to: Binder(self) { base, event in
                base.add(event: event)
            })
            .disposed(by: disposeBag)
        
        EventsMediator.shared.didDelete
            .emit(to: Binder(self) { base, eventId in
                base.delete(eventId: eventId)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension EventsNotificationsManager {
    func add(event: Event) {
        delete(eventId: event.id)
        
        let calendar = Calendar.current
        
        let content = UNMutableNotificationContent()
        content.title = event.repeatMode.title
        content.body = event.note
        content.sound = UNNotificationSound.default
        
        var repeats: Bool {
            switch event.repeatMode {
            case .never:
                return false
            default:
                return true
            }
        }
        
        var dateMatching: DateComponents {
            switch event.repeatMode {
            case .never:
                return calendar.dateComponents([.hour, .minute, .day, .month, .year], from: event.date)
            case .daily:
                return calendar.dateComponents([.hour, .minute], from: event.date)
            case .weekly:
                return calendar.dateComponents([.hour, .minute, .weekday], from: event.date)
            case .monthly:
                return calendar.dateComponents([.hour, .minute, .day, .weekOfMonth], from: event.date)
            case .yearly:
                return calendar.dateComponents([.hour, .minute, .day, .month, .month], from: event.date)
            }
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: repeats)
        let request = UNNotificationRequest(identifier: event.id, content: content, trigger: trigger)
        center.add(request)
    }
    
    func delete(eventId: String) {
        center.removeDeliveredNotifications(withIdentifiers: [eventId])
        center.removePendingNotificationRequests(withIdentifiers: [eventId])
    }
}
