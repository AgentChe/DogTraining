//
//  GameTrainingResultViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import RxSwift
import RxCocoa

final class GameTrainingResultViewModel {
    lazy var skillLevel = makeSkillLevel()
    lazy var gameGroup = makeGameGroup()
    
    private let gameTraining: Driver<GameTraining>
    
    private lazy var gamesManager = GamesManager()
    private lazy var contentManager = ContentManager()
    
    init(gameTraining: GameTraining) {
        self.gameTraining = BehaviorRelay(value: gameTraining).asDriver()
    }
}

// MARK: Public
extension GameTrainingResultViewModel {
    func makeSkillLevel() -> Driver<SkillLevel> {
        gameTraining
            .flatMapLatest { [weak self] gameTraining -> Driver<SkillLevel> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainLevels(forceUpdate: false)
                    .compactMap { skillLevels -> SkillLevel? in
                        skillLevels.first(where: { $0.id == gameTraining.game.skillLevelId })
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeGameGroup() -> Driver<GameGroup> {
        gameTraining
            .flatMapLatest { [weak self] gameTraining -> Driver<GameGroup> in
                guard let self = self else {
                    return .never()
                }
                
                return self.gamesManager
                    .obtainGameGroups(forceUpdate: false)
                    .compactMap { gamesGroups -> GameGroup? in
                        gamesGroups.first(where: { $0.id == gameTraining.game.gameGroupId })
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
