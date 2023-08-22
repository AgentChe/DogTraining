//
//  GamesTableView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 22.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class GamesTableView: UITableView {
    lazy var elements = [GamesTableElement]()
    
    private lazy var didTapGameTrigger = PublishRelay<Game>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension GamesTableView {
    func setup(elements: [GamesTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapGame: Signal<Game> {
        didTapGameTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension GamesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: GamesTableCell.self)) as! GamesTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension GamesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        220.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        didTapGameTrigger.accept(element.game)
    }
}

// MARK: Private
private extension GamesTableView {
    func initialize() {
        register(GamesTableCell.self, forCellReuseIdentifier: String(describing: GamesTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
