//
//  CommandsTrainingTemplateViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import RxSwift
import RxCocoa

final class CommandsTrainingTemplateViewModel {
    enum Route {
        case training(customerTrainingId: Int)
        case calendar(customerTrainingId: Int)
    }
    enum Source {
        case training(Training)
        case plan(PlanTraining)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTapStartTraining = PublishRelay<Void>()
    lazy var didTapCalendar = PublishRelay<Void>()
    
    lazy var route = makeRoute()
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    lazy var assignActivity = RxActivityIndicator()
    
    private lazy var training = makeTraining()
    private lazy var commandsGroups = makeCommandsGroups()
    private lazy var skillLevels = makeSkillLevels()
    private let source: Driver<Source>
    private lazy var skillLevelId = makeSkillLevelId()
    
    private lazy var commandsManager = CommandsManager()
    private lazy var trainingsManager = TrainingsManager()
    private lazy var profileManager = ProfileManager()
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(source: Source) {
        self.source = BehaviorRelay(value: source).asDriver()
    }
}

// MARK: Private
private extension CommandsTrainingTemplateViewModel {
    func makeRoute() -> Driver<Route> {
        enum Action {
            case training
            case calendar
        }
        
        return Observable<Action>
            .merge(
                didTapCalendar.map { _ in .calendar },
                didTapStartTraining.map { _ in .training }
            )
            .withLatestFrom(training) { ($0, $1) }
            .withUnretained(self)
            .flatMapLatest { base, args -> Driver<Route> in
                let (action, training) = args
                
                func source() -> Single<Route> {
                    base.trainingsManager.assignTraining(id: training.id)
                        .map { assignedTraining -> Route in
                            guard let assignedTraining else {
                                throw ContentError(.notContent)
                            }
                            
                            switch action {
                            case .training:
                                return .training(customerTrainingId: assignedTraining.customerTrainingId)
                            case .calendar:
                                return .calendar(customerTrainingId: assignedTraining.customerTrainingId)
                            }
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = base.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return base.observableRetrySingle
                    .retry(
                        source: source,
                        trigger: trigger
                    )
                    .trackActivity(base.assignActivity)
                    .asDriver(onErrorDriveWith: .never())
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeElements() -> Driver<[TrainingTemplateTableElement]> {
        Driver
            .combineLatest(
                training,
                commandsGroups,
                skillLevels
            )
            .map { training, commandsGroups, skillLevels -> [TrainingTemplateTableElement] in
                var result = [TrainingTemplateTableElement]()
                
                let headerElement = TrainingTemplateHeaderElement(
                    image: training.image,
                    name: training.name,
                    skillLevel: skillLevels.first(where: { $0.id == training.levelId })?.name ?? ""
                )
                result.append(.header(headerElement))
                
                result.append(contentsOf: [
                    .offset(24.scale),
                    .buttons
                ])
                
                let commandsGroupsElement = commandsGroups.filter { commandGroup -> Bool in
                    training.commandGroupsIds.contains(where: { $0 == commandGroup.id })
                }
                result.append(contentsOf: [
                    .offset(32.scale),
                    .commandsGroups(commandsGroupsElement)
                ])
                
                training.commands.forEach { command in
                    result.append(contentsOf: [
                        .offset(16.scale),
                        .command(command)
                    ])
                }
                
                return result
            }
    }
    
    func makeTraining() -> Driver<Training> {
        Driver
            .combineLatest(source, skillLevelId)
            .flatMapLatest { [weak self] input, skillLevelId -> Driver<Training> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Training> {
                    let result: Single<Training?>
                    
                    switch input {
                    case .training(let training):
                        result = .just(training)
                    case .plan(let plan):
                        result = self.trainingsManager
                            .obtainTrainingDetails(customerTrainingId: plan.customerTrainingId)
                            .map { $0?.training }
                    }
                    
                    return result
                        .flatMap { training -> Single<Training> in
                            guard let training = training else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(training)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeSkillLevelId() -> Driver<Int> {
        profileManager
            .obtainProfile(forceUpdate: false)
            .compactMap { $0?.skillLevelId }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeCommandsGroups() -> Driver<[CommandGroup]> {
        commandsManager
            .obtainCommandsGroups(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
}
