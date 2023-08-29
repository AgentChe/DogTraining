//
//  EventsAssembly.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 28.08.2023.
//

import UIKit

final class EventsAssembly {
    private weak var parentVC: UIViewController?
    
    func createEvent(from vc: UIViewController) {
        self.parentVC = vc
        
        let chooseEventTypeVC = ChooseEventTypeViewController.make(didClose: { chooseEventTypeVC in
            chooseEventTypeVC.dismiss(animated: true)
        }, didSelect: { eventType, chooseEventTypeVC in
            chooseEventTypeVC.dismiss(animated: true) { [weak self] in
                let createVC = CreateEventViewController.make(eventType: eventType, didClose: { createVC in
                    createVC.dismiss(animated: true)
                })
                self?.parentVC?.present(createVC, animated: true)
            }
        })
        parentVC?.present(chooseEventTypeVC, animated: true)
    }
}
