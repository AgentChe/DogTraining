//
//  CommandTrainingAssembly.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

final class CommandTrainingAssembly {}

// MARK: Public
extension CommandTrainingAssembly {
    func startTraining(from parent: UIViewController, customerCommandId: Int) {
        let vc = CommandTrainingViewController.make(customerCommandId: customerCommandId) { commandTraining in
            let resultVC = CommandTrainingResultViewController.make(commandTraining: commandTraining)
            parent.present(resultVC, animated: true)
        }
        parent.present(vc, animated: true)
    }
}
