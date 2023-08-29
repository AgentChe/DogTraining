//
//  ChooseEventTypeTableView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 28.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class ChooseEventTypeTableView: UITableView {
    lazy var elements = [EventType]()
    
    private lazy var didSelectElementTrigger = PublishRelay<EventType>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ChooseEventTypeTableView {
    func setup(elements: [EventType]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelectElement: Signal<EventType> {
        didSelectElementTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension ChooseEventTypeTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: ChooseEventTypeTableCell.self)) as! ChooseEventTypeTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension ChooseEventTypeTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectElementTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension ChooseEventTypeTableView {
    func initialize() {
        register(ChooseEventTypeTableCell.self, forCellReuseIdentifier: String(describing: ChooseEventTypeTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
