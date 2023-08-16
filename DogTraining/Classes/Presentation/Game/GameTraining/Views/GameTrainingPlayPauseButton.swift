//
//  GameTrainingPlayPauseButton.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit

final class GameTrainingPlayPauseButton: TapAreaButton {
    enum State {
        case play, pause
    }
    
    var stateCode = State.pause {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func invertedState() {
        switch stateCode {
        case .play:
            stateCode = .pause
        case .pause:
            stateCode = .play
        }
    }
}

// MARK: Private
private extension GameTrainingPlayPauseButton {
    func update() {
        switch stateCode {
        case .play:
            setImage(UIImage(named: "GameTraining.Pause"), for: .normal)
        case .pause:
            setImage(UIImage(named: "GameTraining.Play"), for: .normal)
        }
    }
}
