//
//  GameTrainingLifeCyrcle.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import Foundation

protocol GameTrainingLifeCyrcleDelegate: AnyObject {
    func gameTrainingPrepare()
    func gameTrainingReadyIn(seconds: Int)
    func gameTrainingPrepared()
    func gameTrainingDidStart()
    func gameTrainingTick(seconds: Int)
    func gameTrainigPaused()
    func gameTrainingStopped(totalSeconds: Int)
}

final class GameTrainingLifeCyrcle {
    weak var delegate: GameTrainingLifeCyrcleDelegate?
    
    private var trainingSeconds = 0
    
    private var timer: Timer?
}

// MARK: Public
extension GameTrainingLifeCyrcle {
    func startTraining() {
        delegate?.gameTrainingPrepare()
        
        var prepareLeft = 6
        
        delegate?.gameTrainingReadyIn(seconds: prepareLeft - 1)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            if prepareLeft > 0 {
                prepareLeft -= 1
                
                if prepareLeft == 1 {
                    self.delegate?.gameTrainingPrepared()
                } else if prepareLeft == 0 {
                    self.delegate?.gameTrainingDidStart()
                } else {
                    self.delegate?.gameTrainingReadyIn(seconds: prepareLeft - 1)
                }
            } else {
                self.trainingSeconds += 1
                
                self.delegate?.gameTrainingTick(seconds: self.trainingSeconds)
            }
        }
    }
    
    func refreshTraining() {
        timer?.invalidate()
        timer = nil
        
        trainingSeconds = 0
        
        startTraining()
    }
    
    func pauseTraining() {
        timer?.invalidate()
        timer = nil
        
        delegate?.gameTrainigPaused()
    }
    
    func continueTraining() {
        delegate?.gameTrainingDidStart()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            self.trainingSeconds += 1
            
            self.delegate?.gameTrainingTick(seconds: self.trainingSeconds)
        }
    }
    
    func stopTraining() {
        timer?.invalidate()
        timer = nil
        
        delegate?.gameTrainingStopped(totalSeconds: trainingSeconds)
    }
}
