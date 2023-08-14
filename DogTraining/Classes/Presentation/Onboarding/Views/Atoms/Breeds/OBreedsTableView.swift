//
//  OBreedsTableView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 11.08.2023.
//

import UIKit

final class OBreedsTableView: UITableView {
    var didSelect: ((Breed) -> Void)?
    
    lazy var elements = [Breed]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OBreedsTableView {
    func setup(elements: [Breed]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension OBreedsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: OBreedsTableCell.self), for: indexPath) as! OBreedsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension OBreedsTableView: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(elements[indexPath.row])
    }
}

// MARK: Private
private extension OBreedsTableView {
    func initialize() {
        register(OBreedsTableCell.self, forCellReuseIdentifier: String(describing: OBreedsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
