//
//  GameTrainingAssembly.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

final class GameTrainingAssembly {}

// MARK: Public
extension GameTrainingAssembly {
    func startTraining(from parent: UIViewController, customerGameId: Int) {
        let vc = GameTrainingViewController.make(customerGameId: customerGameId) { gameTraining in
            let resultVC = GameTrainingResultViewController.make(gameTraining: gameTraining)
            parent.present(resultVC, animated: true)
        }
        parent.present(vc, animated: true)
    }
}
