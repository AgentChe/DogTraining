//
//  HomeViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTapPlanDay = PublishRelay<Date>()
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var homeKit = makeHomeKit()
    private lazy var skillLevels = makeSkillLevels()
    private lazy var commandsGroups = makeCommandsGroups()
    private lazy var gamesGroups = makeGamesGroups()
    private lazy var planDay = makePlanDay()
    
    private lazy var contentManager = ContentManager()
    private lazy var gamesManager = GamesManager()
    private lazy var trainingsManager = TrainingsManager()
    private lazy var commandsManager = CommandsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension HomeViewModel {
    func makeElements() -> Driver<[HomeTableElement]> {
        Driver
            .combineLatest(homeKit, skillLevels, commandsGroups, gamesGroups, planDay)
            .map { [weak self] homeKit, skillLevels, commandsGroups, gamesGroups, planDay -> [HomeTableElement] in
                guard let self = self, let homeKit = homeKit else {
                    return []
                }
                
                var result = [HomeTableElement]()
                
                let stats = self.statsElements(homeKit: homeKit, skillLevels: skillLevels)
                result.append(contentsOf: stats)
                
                let dailyPicks = self.dailyPicksElements(
                    homeKit: homeKit,
                    skillLevels: skillLevels,
                    gamesGroups: gamesGroups
                )
                result.append(contentsOf: dailyPicks)
                
                let plan = self.planElements(
                    homeKit: homeKit,
                    planDay: planDay
                )
                result.append(contentsOf: plan)
                
                let planTrainings = self.planTrainingsElements(
                    homeKit: homeKit,
                    skillLevels: skillLevels,
                    planDay: planDay
                )
                result.append(contentsOf: planTrainings)
                
                let commandsGroupsElements: [HomeTableElement] = [
                    .offset(40.scale),
                    .commandsGroups(commandsGroups)
                ]
                result.append(contentsOf: commandsGroupsElements)
                
                let commands = self.tryCommandsElements(
                    homeKit: homeKit,
                    skillLevels: skillLevels,
                    commandsGroups: commandsGroups
                )
                result.append(contentsOf: commands)
                
                let games = self.gamesElements(
                    homeKit: homeKit,
                    skillLevels: skillLevels
                )
                result.append(contentsOf: games)
                
                return result
            }
    }
    
    func makeHomeKit() -> Driver<HomeKit?> {
        let triggers = Signal<Void>.merge(
            CommandsMediator.shared.didLogProgress.map { _ in Void() },
            CommandsMediator.shared.didSchedule.map { _ in Void() },
            GamesMediator.shared.didLogProgress.map { _ in Void() },
            GamesMediator.shared.didSchedule.map { _ in Void() },
            TrainingsMediator.shared.didLogProgress.map { _ in Void() },
            TrainingsMediator.shared.didSchedule.map { _ in Void() },
            PlanMediator.shared.didReinit.map { _ in Void() },
            ProfileMediator.shared.skillLevelIdChange.map { _ in Void() }
        )
        
        return triggers
            .startWith(Void())
            .flatMapLatest { [weak self] void -> Driver<HomeKit?> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<HomeKit?> {
                    self.contentManager
                        .obtainHomeKit()
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
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeCommandsGroups() -> Driver<[CommandGroup]> {
        commandsManager
            .obtainCommandsGroups(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeGamesGroups() -> Driver<[GameGroup]> {
        gamesManager
            .obtainGameGroups(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makePlanDay() -> Driver<Date> {
        didTapPlanDay
            .startWith(Date())
            .asDriver(onErrorDriveWith: .never())
    }
}

// MARK: Private (Additional)
private extension HomeViewModel {
    func statsElements(homeKit: HomeKit, skillLevels: [SkillLevel]) -> [HomeTableElement] {
        guard let skillLevel = skillLevels.first(where: { $0.id == homeKit.levelId }) else {
            return []
        }
        
        let element = HomeStatsElement(
            score: homeKit.score,
            skillLevel: skillLevel
        )
        
        return [.stats(element)]
    }
    
    func dailyPicksElements(
        homeKit: HomeKit,
        skillLevels: [SkillLevel],
        gamesGroups: [GameGroup]
    ) -> [HomeTableElement] {
        let games = homeKit.dailyGames.compactMap { game -> DailyPicksElement? in
            guard
                let skillLevel = skillLevels.first(where: { $0.id == game.skillLevelId }),
                let gameGroup = gamesGroups.first(where: { $0.id == game.gameGroupId })
            else {
                return nil
            }
            
            return DailyPicksElement(
                game: game,
                skillLevel: skillLevel,
                gameGroup: gameGroup
            )
        }
        
        let trainings = homeKit.dailyTrainings.compactMap { training -> DailyPicksElement? in
            guard let skillLevel = skillLevels.first(where: { $0.id == training.levelId }) else {
                return nil
            }
            
            return DailyPicksElement(
                training: training,
                skillLevel: skillLevel
            )
        }
        
        let elements = games + trainings
        
        if elements.isEmpty {
            return []
        }
        
        return [
            .offset(32.scale),
            .title(.large("Home.DailyPicks".localized)),
            .offset(16.scale),
            .dailyPicks(elements)
        ]
    }
    
    func planElements(
        homeKit: HomeKit,
        planDay: Date
    ) -> [HomeTableElement] {
        let calendar = Calendar.current
        let today = Date()
        let todayDayOfWeek = calendar.component(.weekday, from: today)
        
        guard
            let weekdaysRange = calendar.range(of: .weekday, in: .weekOfYear, for: today),
            let index = weekdaysRange.firstIndex(of: calendar.firstWeekday)
        else {
            return []
        }
        
        let weekdays = weekdaysRange[index...] + weekdaysRange[..<index].map { $0 + weekdaysRange.count }
        let dates = weekdays.compactMap { calendar.date(byAdding: .day, value: $0 - todayDayOfWeek, to: today) }
        
        let models = dates.map { day -> PlanWeekDayButton.Model in
            PlanWeekDayButton.Model(
                day: day,
                isCurrentDay: calendar.isDateInToday(day),
                isSelected: day.isEqualByDays(with: planDay),
                planStatus: homeKit.plan.first(where: { $0.day.isEqualByDays(with: day) })?.status
            )
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        
        let planDayLocalized = formatter.string(from: planDay)
        let planDayTitle = String(format: "Home.Schedule".localized, planDayLocalized)
        
        return [
            .offset(40.scale),
            .title(.large(planDayTitle)),
            .offset(16.scale),
            .plan(models)
        ]
    }
    
    func planTrainingsElements(
        homeKit: HomeKit,
        skillLevels: [SkillLevel],
        planDay: Date
    ) -> [HomeTableElement] {
        let empty: [HomeTableElement] = [
            .offset(16.scale),
            .noTrainings,
            .offset(16.scale),
            .addTraining
        ]
        
        guard let plan = homeKit.plan.first(where: { $0.day.isEqualByDays(with: planDay) }) else {
            return empty
        }
        
        if plan.games.isEmpty && plan.commands.isEmpty && plan.trainings.isEmpty {
            return empty
        }
        
        let baseGames = plan.games.filter { $0.status != .completed }
        let completedGames = plan.games.filter { $0.status == .completed }
        
        let baseTrainings = plan.trainings.filter { $0.status != .completed }
        let completedTrainings = plan.trainings.filter { $0.status == .completed }
        
        let baseCommands = plan.commands.filter { $0.status != .completed }
        let completedCommands = plan.commands.filter { $0.status == .completed }
        
        var result = [HomeTableElement]()
        
        func fill(from games: [PlanGame]) {
            games.enumerated().forEach { index, planGame in
                guard let skillLevel = skillLevels.first(where: { $0.id == planGame.levelId }) else {
                    return
                }
                
                let element = HomePlanTrainingElement(
                    training: .game(planGame),
                    skillLevel: skillLevel
                )
                result.append(contentsOf: [
                    .offset(16.scale),
                    .planTraining(element)
                ])
            }
        }
        
        func fill(from trainings: [PlanTraining]) {
            trainings.enumerated().forEach { index, planTraining in
                guard let skillLevel = skillLevels.first(where: { $0.id == planTraining.levelId }) else {
                    return
                }
                
                let element = HomePlanTrainingElement(
                    training: .training(planTraining),
                    skillLevel: skillLevel
                )
                result.append(contentsOf: [
                    .offset(16.scale),
                    .planTraining(element)
                ])
            }
        }
        
        func fill(from commands: [PlanCommand]) {
            commands.enumerated().forEach { index, planCommand in
                guard let skillLevel = skillLevels.first(where: { $0.id == planCommand.levelId }) else {
                    return
                }
                
                let element = HomePlanTrainingElement(
                    training: .command(planCommand),
                    skillLevel: skillLevel
                )
                result.append(contentsOf: [
                    .offset(16.scale),
                    .planTraining(element)
                ])
            }
        }
        
        if !baseGames.isEmpty {
            fill(from: baseGames)
        }
        if !baseTrainings.isEmpty {
            fill(from: baseTrainings)
        }
        if !baseCommands.isEmpty {
            fill(from: baseCommands)
        }
        
        if !completedGames.isEmpty {
            result.append(contentsOf: [
                .offset(24.scale),
                .title(.small("Home.Completed".localized))
            ])
            
            fill(from: completedGames)
        }
        if !completedTrainings.isEmpty {
            if completedGames.isEmpty {
                result.append(contentsOf: [
                    .offset(24.scale),
                    .title(.small("Home.Completed".localized))
                ])
            }
            
            fill(from: completedTrainings)
        }
        if !completedCommands.isEmpty {
            if completedGames.isEmpty && completedTrainings.isEmpty {
                result.append(contentsOf: [
                    .offset(24.scale),
                    .title(.small("Home.Completed".localized))
                ])
            }
            
            fill(from: completedCommands)
        }
        
        result.append(contentsOf: [
            .offset(24.scale),
            .addTraining
        ])
        
        return result
    }
    
    func tryCommandsElements(
        homeKit: HomeKit,
        skillLevels: [SkillLevel],
        commandsGroups: [CommandGroup]
    ) -> [HomeTableElement] {
        guard !homeKit.tryCommands.isEmpty else {
            return []
        }
        
        var result: [HomeTableElement] = [
            .offset(43.scale),
            .tryCommandsTitle("Home.TryCommands".localized),
            .offset(19.scale)
        ]
        
        homeKit.tryCommands.enumerated().forEach { index, command in
            guard
                let commandGroup = commandsGroups.first(where: { $0.id == command.commandGroupId }),
                let skillLevel = skillLevels.first(where: { $0.id == command.skillLevelId })
            else {
                return
            }
            
            let element = HomeCommandElement(
                command: command,
                commandGroup: commandGroup,
                skillLevel: skillLevel
            )
            result.append(.command(element))
            
            if (homeKit.tryCommands.count - 1) != index {
                result.append(.offset(16.scale))
            }
        }
        
        return result
    }
    
    func gamesElements(
        homeKit: HomeKit,
        skillLevels: [SkillLevel]
    ) -> [HomeTableElement] {
        let gamesElements = homeKit.games.compactMap { game -> HomeGameElement? in
            guard let skillLevel = skillLevels.first(where: { $0.id == homeKit.levelId }) else {
                return nil
            }
            
            return HomeGameElement(
                game: game,
                skillLevel: skillLevel
            )
        }.prefix(3)
        
        guard !gamesElements.isEmpty else {
            return []
        }
        
        return [
            .offset(43.scale),
            .gamesTitle("Home.Games".localized),
            .offset(19.scale),
            .games(Array(gamesElements))
        ]
    }
}
