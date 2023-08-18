//
//  CommandsTrainingLifeCyrcle.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.03.2023.
//

import Foundation

protocol CommandsTrainingLifeCyrcleDelegate: AnyObject {
    func commandsTrainingPrepare()
    func commandsTrainingReadyIn(seconds: Int)
    func commandsTrainingPrepared()
    func commandsTrainingDidStart()
    func commandsTrainingTick(seconds: Int)
    func commandsTrainigPaused()
    func commandsTrainingStopped(totalSeconds: Int, commandId: Int)
    func commandsTrainingFinish(totalSeconds: Int, commandId: Int)
    func commandsTrainingStartStep()
}

final class CommandsTrainingLifeCyrcle {
    weak var delegate: CommandsTrainingLifeCyrcleDelegate?
    
    private var trainingSeconds = 0
    
    private var timer: Timer?
    private var trainingTimer: Timer?
}

// MARK: Public
extension CommandsTrainingLifeCyrcle {
    func start() {
        delegate?.commandsTrainingPrepare()
        
        timer?.invalidate()
        timer = nil
        
        var prepareLeft = 6
        
        delegate?.commandsTrainingReadyIn(seconds: prepareLeft - 1)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            if prepareLeft >= 0 {
                prepareLeft -= 1
                
                switch prepareLeft {
                case 0:
                    self.delegate?.commandsTrainingDidStart()
                    self.delegate?.commandsTrainingStartStep()
                    
                    self.timer?.invalidate()
                    self.timer = nil
                case 1:
                    self.delegate?.commandsTrainingPrepared()
                default:
                    self.delegate?.commandsTrainingReadyIn(seconds: prepareLeft - 1)
                }
            }
        }
    }
    
    func startTraining() {
        trainingTimer?.invalidate()
        trainingTimer = nil
        trainingSeconds = 0
        delegate?.commandsTrainingTick(seconds: trainingSeconds)
        
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else {
                return
            }
            
            self.trainingSeconds += 1
            self.delegate?.commandsTrainingTick(seconds: self.trainingSeconds)
        }
    }
    
    func pauseTraining() {
        trainingTimer?.invalidate()
        trainingTimer = nil
        
        delegate?.commandsTrainigPaused()
    }
    
    func continueTraining() {
        delegate?.commandsTrainingDidStart()
        
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            self.trainingSeconds += 1
            
            self.delegate?.commandsTrainingTick(seconds: self.trainingSeconds)
        }
    }
    
    func stopTraining(commandId: Int) {
        trainingTimer?.invalidate()
        trainingTimer = nil
        
        delegate?.commandsTrainingStopped(totalSeconds: trainingSeconds, commandId: commandId)
    }
    
    func finishTraining(commandId: Int) {
        trainingTimer?.invalidate()
        trainingTimer = nil
        
        delegate?.commandsTrainingFinish(totalSeconds: trainingSeconds, commandId: commandId)
    }
}
