//
//  OCommandsTableView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 14.08.2023.
//

import UIKit

final class OCommandsTableView: UITableView {
    var didSelect: (() -> Void)?
    
    lazy var elements = [OCommandsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OCommandsTableView {
    func setup(elements: [OCommandsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension OCommandsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: OCommandsTableCell.self)) as! OCommandsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension OCommandsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elements[indexPath.row].marked.toggle()
        
        reloadRows(at: [indexPath], with: .automatic)
        
        didSelect?()
    }
}

// MARK: Private
private extension OCommandsTableView {
    func initialize() {
        register(OCommandsTableCell.self, forCellReuseIdentifier: String(describing: OCommandsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
