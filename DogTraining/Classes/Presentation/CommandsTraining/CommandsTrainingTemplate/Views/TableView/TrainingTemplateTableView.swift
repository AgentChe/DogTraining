//
//  TrainingTemplateTableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

protocol TrainingTemplateTableDelegate: AnyObject {
    func tableDidTappedCalendar()
    func tableDidTappedStartTraining()
    func tableDidTapped(command: Command)
}

final class TrainingTemplateTableView: UITableView {
    weak var mainDelegate: TrainingTemplateTableDelegate?
    
    lazy var elements = [TrainingTemplateTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TrainingTemplateTableView {
    func setup(elements: [TrainingTemplateTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension TrainingTemplateTableView: UITableViewDataSource {
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
        case .header(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TTHeaderCell.self)) as! TTHeaderCell
            cell.setup(element: element)
            return cell
        case .buttons:
            let cell = dequeueReusableCell(withIdentifier: String(describing: TTButtonsCell.self)) as! TTButtonsCell
            cell.didTapCalendar = { [weak self] in
                self?.mainDelegate?.tableDidTappedCalendar()
            }
            cell.didTapStart = { [weak self] in
                self?.mainDelegate?.tableDidTappedStartTraining()
            }
            return cell
        case .commandsGroups(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TTCommandsGroupsCell.self)) as! TTCommandsGroupsCell
            cell.collectionView.setup(elements: element)
            return cell
        case .command(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TTCommandCell.self)) as! TTCommandCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension TrainingTemplateTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .header:
            return UITableView.automaticDimension
        case .buttons:
            return 54.scale
        case .commandsGroups:
            return 86.scale
        case .command:
            return 90.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .command(command) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.tableDidTapped(command: command)
    }
}

// MARK: Private
private extension TrainingTemplateTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(TTHeaderCell.self, forCellReuseIdentifier: String(describing: TTHeaderCell.self))
        register(TTButtonsCell.self, forCellReuseIdentifier: String(describing: TTButtonsCell.self))
        register(TTCommandsGroupsCell.self, forCellReuseIdentifier: String(describing: TTCommandsGroupsCell.self))
        register(TTCommandCell.self, forCellReuseIdentifier: String(describing: TTCommandCell.self))
        
        dataSource = self
        delegate = self
    }
}
