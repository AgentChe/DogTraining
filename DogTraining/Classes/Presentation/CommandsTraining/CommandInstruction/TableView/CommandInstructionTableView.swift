//
//  CommandInstructionTableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 15.03.2023.
//

import UIKit

final class CommandInstructionTableView: UITableView {
    lazy var elements = [CommandInstructionTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CommandInstructionTableView {
    func setup(elements: [CommandInstructionTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CommandInstructionTableView: UITableViewDataSource {
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
        case .image(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CommandInstructionImageCell.self)) as! CommandInstructionImageCell
            cell.setup(element: element)
            return cell
        case .name(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CommandInstructionNameCell.self)) as! CommandInstructionNameCell
            cell.setup(element: element)
            return cell
        case .instruction(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CommandInstructionInstructionCell.self)) as! CommandInstructionInstructionCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension CommandInstructionTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .image:
            return 234.scale
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension CommandInstructionTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(CommandInstructionImageCell.self, forCellReuseIdentifier: String(describing: CommandInstructionImageCell.self))
        register(CommandInstructionNameCell.self, forCellReuseIdentifier: String(describing: CommandInstructionNameCell.self))
        register(CommandInstructionInstructionCell.self, forCellReuseIdentifier: String(describing: CommandInstructionInstructionCell.self))
        
        dataSource = self
        delegate = self
    }
}
