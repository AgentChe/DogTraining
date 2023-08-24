//
//  ProfileTableView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import UIKit

final class ProfileTableView: UITableView {
    lazy var elements = [ProfileTableElement]()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProfileTableView {
    func setup(elements: [ProfileTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ProfileTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .settings(let element):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileSettingsCell.self)) as! ProfileSettingsCell
            cell.setup(element: element)
            return cell
        case .progress(let percent, let level):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileProgressCell.self)) as! ProfileProgressCell
            cell.setup(percent: percent, level: level)
            return cell
        case .addEvent:
            return dequeueReusableCell(withIdentifier: String(describing: ProfileAddEventCell.self), for: indexPath)
        case .stats(let commands, let trainings, let games):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileStatsCell.self), for: indexPath) as! ProfileStatsCell
            cell.setup(
                commandsValue: commands,
                trainingsValue: trainings,
                gamesValue: games
            )
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension ProfileTableView {
    func initialize() {
        register(ProfileSettingsCell.self, forCellReuseIdentifier: String(describing: ProfileSettingsCell.self))
        register(ProfileProgressCell.self, forCellReuseIdentifier: String(describing: ProfileProgressCell.self))
        register(ProfileAddEventCell.self, forCellReuseIdentifier: String(describing: ProfileAddEventCell.self))
        register(ProfileStatsCell.self, forCellReuseIdentifier: String(describing: ProfileStatsCell.self))
        
        dataSource = self
        delegate = self
    }
}
