//
//  GITableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import UIKit

protocol GITableDelegate: AnyObject {
    func giTableDidTappedCalendar()
    func giTableDidTappedStartTraining()
    func giTableDidTappedShowMore()
}

final class GITableView: UITableView {
    weak var mainDelegate: GITableDelegate?
    
    lazy var elements = [GITableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension GITableView {
    func setup(elements: [GITableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension GITableView: UITableViewDataSource {
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
            let cell = dequeueReusableCell(withIdentifier: String(describing: GIHeaderCell.self)) as! GIHeaderCell
            cell.setup(element: element)
            return cell
        case .description(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: GIDescriptionCell.self)) as! GIDescriptionCell
            cell.setup(element: element)
            cell.didTapShowMore = { [weak self] in
                self?.mainDelegate?.giTableDidTappedShowMore()
            }
            return cell
        case .buttons(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: GIButtonsCell.self)) as! GIButtonsCell
            cell.didTapCalendar = { [weak self] in
                self?.mainDelegate?.giTableDidTappedCalendar()
            }
            cell.didTapStart = { [weak self] in
                self?.mainDelegate?.giTableDidTappedStartTraining()
            }
            cell.setup(element: element)
            return cell
        case .instruction(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: GIInstructionCell.self)) as! GIInstructionCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension GITableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .buttons:
            return 54.scale
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension GITableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(GIHeaderCell.self, forCellReuseIdentifier: String(describing: GIHeaderCell.self))
        register(GIDescriptionCell.self, forCellReuseIdentifier: String(describing: GIDescriptionCell.self))
        register(GIButtonsCell.self, forCellReuseIdentifier: String(describing: GIButtonsCell.self))
        register(GIInstructionCell.self, forCellReuseIdentifier: String(describing: GIInstructionCell.self))
        
        dataSource = self
        delegate = self
    }
}
