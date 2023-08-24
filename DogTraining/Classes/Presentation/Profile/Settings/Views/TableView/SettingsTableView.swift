//
//  SettingsTableView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import UIKit
import RxCocoa

final class SettingsTableView: UITableView {
    private lazy var didSelectItemTrigger = PublishRelay<SettingsTableElement>()
    
    private var elements = [SettingsTableElement]()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsTableView {
    func setup(elements: [SettingsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelectItem: Signal<SettingsTableElement> {
        didSelectItemTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SettingsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .item(let type, let isLast, let subtitle):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsItemCell.self)) as! SettingsItemCell
            cell.setup(type: type, isLast: isLast, subtitle: subtitle)
            return cell
        case .header(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsHeaderCell.self)) as! SettingsHeaderCell
            cell.setup(title: title)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .header:
            return UITableView.automaticDimension
        case .item:
            return 64.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItemTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SettingsTableView {
    func initialize() {
        register(SettingsItemCell.self, forCellReuseIdentifier: String(describing: SettingsItemCell.self))
        register(SettingsHeaderCell.self, forCellReuseIdentifier: String(describing: SettingsHeaderCell.self))
        
        dataSource = self
        delegate = self
    }
}
