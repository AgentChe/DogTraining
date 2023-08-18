//
//  CommandsTrainingAssembly.swift
//  Soccer
//
//  Created by Виталий Загороднов on 23.03.2023.
//

import UIKit

final class CommandsTrainingAssembly {}

// MARK: Public
extension CommandsTrainingAssembly {
    func startTraining(from parent: UIViewController, customerTrainingId: Int) {
        let vc = CommandsTrainingViewController.make(customerTrainingId: customerTrainingId) { trainingDetails in
            let resultVC = CommandsTrainingResultViewController.make(trainingDetails: trainingDetails)
            parent.present(resultVC, animated: true)
        }
        
        parent.present(vc, animated: true)
    }
}
