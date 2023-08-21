//
//  TrainViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.03.2023.
//

import RxSwift
import RxCocoa

final class TrainViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didSelectFilter = PublishRelay<TrainFilterView.Filter>()
    
    lazy var sections = makeSections()
    lazy var activity = RxActivityIndicator()
    
    private lazy var articlesSection = makeArticlesSection()
    private lazy var articles = makeArticles()
    private lazy var trainingsSection = makeTrainingsSection()
    private lazy var trainings = makeTrainings()
    private lazy var commandsSection = makeCommandsSection()
    private lazy var commands = makeCommands()
    private lazy var gamesSections = makeGamesSections()
    private lazy var games = makeGames()
    private lazy var gamesGroups = makeGamesGroups()
    private lazy var skillLevel = makeSkillLevel()
    
    private lazy var articlesManager = ArticlesManager()
    private lazy var gamesManager = GamesManager()
    private lazy var commandsManager = CommandsManager()
    private lazy var trainingsManager = TrainingsManager()
    private lazy var profileManger = ProfileManager()
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension TrainViewModel {
    func makeSections() -> Driver<[TrainTableSection]> {
        Driver
            .combineLatest(
                didSelectFilter.asDriver(onErrorDriveWith: .never()),
                trainingsSection,
                commandsSection,
                gamesSections,
                articlesSection
            )
            .map { filter, trainingsSection, commandsSection, gamesSections, articlesSection -> [TrainTableSection] in
                switch filter {
                case .commands:
                    return [trainingsSection, commandsSection]
                case .games:
                    return gamesSections
                case .articles:
                    return [articlesSection]
                }
            }
    }
    
    func makeArticlesSection() -> Driver<TrainTableSection> {
        articles
            .map { articles -> TrainTableSection in
                TrainTableSection(elements: articles.map { .article($0) })
            }
    }
    
    func makeArticles() -> Driver<[Article]> {
        articlesManager
            .obtainArticles(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeTrainingsSection() -> Driver<TrainTableSection> {
        Driver
            .combineLatest(skillLevel, trainings)
            .map { skillLevel, trainings -> TrainTableSection in
            TrainTableSection(
                elements: [
                    .title(.trainings("Train.Trainings".localized)),
                    .trainings(trainings.map { training -> TrainTrainigElement in
                        TrainTrainigElement(
                            element: .training(training),
                            image: training.image,
                            name: training.name,
                            tag1: skillLevel.name,
                            tag2: nil
                        )
                    })
                ]
            )
        }
    }
    
    func makeTrainings() -> Driver<[Training]> {
        skillLevel
            .flatMapLatest { [weak self] skillLevel -> Driver<[Training]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[Training]> {
                    self.trainingsManager
                        .obtainTrainings(levelId: skillLevel.id)
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
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeCommandsSection() -> Driver<TrainTableSection> {
        Driver
            .combineLatest(skillLevel, commands)
            .map { skillLevel, commands -> TrainTableSection in
            TrainTableSection(
                elements: [
                    .title(.commands("Train.Commands".localized)),
                    .trainings(commands.map { command -> TrainTrainigElement in
                        TrainTrainigElement(
                            element: .command(command),
                            image: command.image,
                            name: command.name,
                            tag1: skillLevel.name,
                            tag2: String(format: "TrainingTemplate.Min".localized, command.time)
                        )
                    })
                ]
            )
        }
    }
    
    func makeCommands() -> Driver<[Command]> {
        skillLevel
            .flatMapLatest { [weak self] skillLevel -> Driver<[Command]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[Command]> {
                    self.commandsManager
                        .obtainCommands(commandGroupId: nil, levelId: skillLevel.id)
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
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeGamesSections() -> Driver<[TrainTableSection]> {
        Driver
            .combineLatest(games, gamesGroups, skillLevel)
            .map { games, gamesGroups, skillLevel -> [TrainTableSection] in
                let grouping = Dictionary(grouping: games) { game -> Int in
                    game.gameGroupId
                }
                return grouping.compactMap { gamesGroupId, games -> TrainTableSection? in
                    guard let gamesGroup = gamesGroups.first(where: { $0.id == gamesGroupId }) else {
                        return nil
                    }
                    
                    let elements: [TrainTableElement] = [
                        .title(.gamesGroup(gamesGroup)),
                        .trainings(Array(games.prefix(3)).map { game -> TrainTrainigElement in
                            TrainTrainigElement(
                                element: .game(game),
                                image: game.image,
                                name: game.name,
                                tag1: skillLevel.name,
                                tag2: gamesGroups.first(where: { $0.id == game.gameGroupId })?.name
                            )
                        })
                    ]
                    
                    return TrainTableSection(
                        elements: elements
                    )
                }
            }
    }
    
    func makeGames() -> Driver<[Game]> {
        skillLevel
            .flatMapLatest { [weak self] skillLevel -> Driver<[Game]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[Game]> {
                    self.gamesManager
                        .obtainGames(gameGroupId: nil, levelId: skillLevel.id)
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
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeGamesGroups() -> Driver<[GameGroup]> {
        gamesManager
            .obtainGameGroups(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSkillLevel() -> Driver<SkillLevel> {
        let skillLevelId = Driver
            .merge(
                profileManger
                    .obtainProfile(forceUpdate: false)
                    .compactMap { $0?.skillLevelId }
                    .asDriver(onErrorDriveWith: .never()),
                ProfileMediator.shared.skillLevelIdChange
                    .asDriver(onErrorDriveWith: .never())
            )
        
        return skillLevelId.flatMapLatest { [weak self] skillLevelId -> Driver<SkillLevel> in
            guard let self = self else {
                return .never()
            }
            
            return self.contentManager
                .obtainLevels(forceUpdate: false)
                .compactMap { skillLevels -> SkillLevel? in
                    skillLevels.first(where: { $0.id == skillLevelId })
                }
                .asDriver(onErrorDriveWith: .never())
        }
    }
}
