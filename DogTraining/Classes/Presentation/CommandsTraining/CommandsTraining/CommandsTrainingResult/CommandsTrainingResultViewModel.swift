//
//  CommandsTrainingResultViewModel.swift
//  Soccer
//
//  Created by Виталий Загороднов on 13.04.2023.
//

import Foundation
import RxCocoa
import RxSwift

final class CommandsTrainingResultViewModel {
    lazy var skillLevel = makeSkillLevel()
    
    private let trainingDetails: Driver<TrainingDetails>
    private lazy var contentManager = ContentManager()
    
    init(trainingDetails: TrainingDetails) {
        self.trainingDetails = BehaviorRelay(value: trainingDetails).asDriver()
    }
}

// MARK: Public
extension CommandsTrainingResultViewModel {
    func makeSkillLevel() -> Driver<SkillLevel> {
        trainingDetails
            .flatMapLatest { [weak self] trainingDetails -> Driver<SkillLevel> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainLevels(forceUpdate: false)
                    .compactMap { skillLevels -> SkillLevel? in
                        skillLevels.first(where: { $0.id == trainingDetails.training.levelId })
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
