//
//  CommandsTableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit

protocol CommandsTableDelegate: AnyObject {
    func commandsTableDidTap(element: CommandsTableElement)
}

final class CommandsTableView: UITableView {
    weak var mainDelegate: CommandsTableDelegate?
    
    lazy var elements = [CommandsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CommandsTableView {
    func setup(elements: [CommandsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CommandsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: CommandsTableCell.self)) as! CommandsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension CommandsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        220.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        mainDelegate?.commandsTableDidTap(element: element)
    }
}

// MARK: Private
private extension CommandsTableView {
    func initialize() {
        register(CommandsTableCell.self, forCellReuseIdentifier: String(describing: CommandsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
