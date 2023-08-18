//
//  TrainFilterView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.03.2023.
//

import UIKit

final class TrainFilterView: UIView {
    enum Filter {
        case commands, games
    }
    
    var filter = Filter.commands {
        didSet {
            update()
        }
    }
    
    lazy var separator = makeSeparator()
    lazy var commandsButton = makeButton(text: "Train.Filter.Commands".localized)
    lazy var gamesButton = makeButton(text: "Train.Filter.Games".localized)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TrainFilterView {
    func update() {
        commandsButton.marked = filter == .commands
        gamesButton.marked = filter == .games
    }
}

// MARK: Make constraints
private extension TrainFilterView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            commandsButton.widthAnchor.constraint(equalToConstant: 111.scale),
            commandsButton.heightAnchor.constraint(equalToConstant: 34.scale),
            commandsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            commandsButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gamesButton.widthAnchor.constraint(equalToConstant: 68.scale),
            gamesButton.heightAnchor.constraint(equalToConstant: 34.scale),
            gamesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 147.scale),
            gamesButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TrainFilterView {
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 233, green: 225, blue: 217)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton(text: String) -> TrainFilterButton {
        let view = TrainFilterButton(text: text)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
