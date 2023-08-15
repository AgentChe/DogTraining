//
//  HomeTableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit

protocol HomeTableViewDelegate: AnyObject {
    func homeTableDidTap(game: Game)
    func homeTableDidTap(training: Training)
    func homeTableDidTap(planDay: Date)
    func homeTableDidTap(planGame: PlanGame)
    func homeTableDidTap(planTraining: PlanTraining)
    func homeTableDidTap(planCommand: PlanCommand)
    func homeTableDidTapAddTraining()
    func homeTableDidTap(commandGroup: CommandGroup)
    func homeTableDidTapTryCommands()
    func homeTableDidTapGames()
    func homeTableDidTap(command: Command)
}

final class HomeTableView: UITableView {
    weak var mainDelegate: HomeTableViewDelegate?
    
    lazy var elements = [HomeTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeTableView {
    func setup(elements: [HomeTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension HomeTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .offset:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeTitleCell.self)) as! HomeTitleCell
            cell.setup(element: element)
            return cell
        case .stats(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeStatsCell.self)) as! HomeStatsCell
            cell.setup(element: element)
            return cell
        case .dailyPicks(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: DailyPicksTableCell.self)) as! DailyPicksTableCell
            cell.collectionView.setup(elements: element)
            cell.collectionView.didTap = { [weak self] dailyPicks in
                switch dailyPicks {
                case .game(let game):
                    self?.mainDelegate?.homeTableDidTap(game: game)
                case .training(let training):
                    self?.mainDelegate?.homeTableDidTap(training: training)
                }
            }
            return cell
        case .plan(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: PlanWeekdaysCell.self), for: indexPath) as! PlanWeekdaysCell
            cell.setup(element: element)
            cell.didTap = { [weak self] day in
                self?.mainDelegate?.homeTableDidTap(planDay: day)
            }
            return cell
        case .planTraining(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomePlanTrainingCell.self), for: indexPath) as! HomePlanTrainingCell
            cell.setup(element: element)
            return cell
        case .noTrainings:
            return dequeueReusableCell(withIdentifier: String(describing: HomeNoTrainingsCell.self), for: indexPath)
        case .addTraining:
            return dequeueReusableCell(withIdentifier: String(describing: HomeAddTrainingCell.self), for: indexPath)
        case .commandsGroups(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeCommandsGroupsCell.self)) as! HomeCommandsGroupsCell
            cell.collectionView.setup(elements: element)
            cell.collectionView.didTap = { [weak self] commandGroup in
                self?.mainDelegate?.homeTableDidTap(commandGroup: commandGroup)
            }
            return cell
        case .tryCommandsTitle(let element), .gamesTitle(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SeeAllTableCell.self)) as! SeeAllTableCell
            cell.setup(element: element)
            return cell
        case .command(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeCommandCell.self)) as! HomeCommandCell
            cell.setup(element: element)
            return cell
        case .games(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeGamesCell.self)) as! HomeGamesCell
            cell.collectionView.setup(elements: element)
            cell.collectionView.didTap = { [weak self] game in
                self?.mainDelegate?.homeTableDidTap(game: game)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension HomeTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .stats:
            return 56.scale
        case .dailyPicks:
            return 330.scale
        case .plan:
            return 93.scale
        case .planTraining:
            return 122.scale
        case .noTrainings:
            return 122.scale
        case .addTraining:
            return 54.scale
        case .commandsGroups(let elements):
            guard let commandGroup = elements.first else {
                return 0
            }
            
            return HomeCommandsGroupsCollectionCell.size(for: commandGroup).height * 2 + 16.scale
        case .tryCommandsTitle, .gamesTitle:
            return 30.scale
        case .command:
            return 90.scale
        case .games:
            return 330.scale
        case .title:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .planTraining(let element):
            switch element.training {
            case .game(let game):
                mainDelegate?.homeTableDidTap(planGame: game)
            case .command(let command):
                mainDelegate?.homeTableDidTap(planCommand: command)
            case .training(let training):
                mainDelegate?.homeTableDidTap(planTraining: training)
            }
        case .addTraining:
            mainDelegate?.homeTableDidTapAddTraining()
        case .tryCommandsTitle:
            mainDelegate?.homeTableDidTapTryCommands()
        case .gamesTitle:
            mainDelegate?.homeTableDidTapGames()
        case .command(let element):
            mainDelegate?.homeTableDidTap(command: element.command)
        default:
            return
        }
    }
}

// MARK: Private
private extension HomeTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(DailyPicksTableCell.self, forCellReuseIdentifier: String(describing: DailyPicksTableCell.self))
        register(HomeCommandsGroupsCell.self, forCellReuseIdentifier: String(describing: HomeCommandsGroupsCell.self))
        register(PlanWeekdaysCell.self, forCellReuseIdentifier: String(describing: PlanWeekdaysCell.self))
        register(HomeGamesCell.self, forCellReuseIdentifier: String(describing: HomeGamesCell.self))
        register(HomeTitleCell.self, forCellReuseIdentifier: String(describing: HomeTitleCell.self))
        register(HomeStatsCell.self, forCellReuseIdentifier: String(describing: HomeStatsCell.self))
        register(HomePlanTrainingCell.self, forCellReuseIdentifier: String(describing: HomePlanTrainingCell.self))
        register(HomeNoTrainingsCell.self, forCellReuseIdentifier: String(describing: HomeNoTrainingsCell.self))
        register(HomeAddTrainingCell.self, forCellReuseIdentifier: String(describing: HomeAddTrainingCell.self))
        register(SeeAllTableCell.self, forCellReuseIdentifier: String(describing: SeeAllTableCell.self))
        register(HomeCommandCell.self, forCellReuseIdentifier: String(describing: HomeCommandCell.self))
        
        dataSource = self
        delegate = self
    }
}
