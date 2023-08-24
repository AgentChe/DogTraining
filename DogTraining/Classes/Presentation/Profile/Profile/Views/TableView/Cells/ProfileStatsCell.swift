//
//  ProfileStatsCell.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import UIKit

final class ProfileStatsCell: UITableViewCell {
    lazy var titlelabel = makeLabel()
    lazy var commandsStats = makeStatsView()
    lazy var trainingsStats = makeStatsView()
    lazy var gamesStats = makeStatsView()
    lazy var container = makeContainer()
    lazy var pageContainer = makePageContainer()
    lazy var page1 = makePage(color: Appearance.black)
    lazy var page2 = makePage(color: Appearance.black.withAlphaComponent(0.4))
    lazy var page3 = makePage(color: Appearance.black.withAlphaComponent(0.4))
    
    private lazy var centerCommandsStatConstraint = NSLayoutConstraint()
    private lazy var centerTrainingsStatConstraint = NSLayoutConstraint()
    private lazy var centerGamesStatConstraint = NSLayoutConstraint()
    private lazy var widthPage1Constraint = NSLayoutConstraint()
    private lazy var widthPage2Constraint = NSLayoutConstraint()
    private lazy var widthPage3Constraint = NSLayoutConstraint()
    
    private lazy var leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeHandler))
    private lazy var rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeHandler))
    
    private lazy var currentPage = 1
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProfileStatsCell {
    func setup(commandsValue: String, trainingsValue: String, gamesValue: String) {
        commandsStats.setup(value: commandsValue, subtitle: "Profile.Completed.Commands".localized)
        trainingsStats.setup(value: trainingsValue, subtitle: "Profile.Completed.Trainings".localized)
        gamesStats.setup(value: gamesValue, subtitle: "Profile.Completed.Games".localized)
    }
}

// MARK: Private
private extension ProfileStatsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        container.addGestureRecognizer(leftSwipe)
        container.addGestureRecognizer(rightSwipe)
    }
    
    @objc
    func leftSwipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer) {
        guard gestureRecognizer.state == .ended else {
            return
        }
        
        currentPage += 1
        if currentPage > 3 {
            currentPage = 3
        }
        
        update()
    }
    
    @objc
    func rightSwipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer) {
        guard gestureRecognizer.state == .ended else {
            return
        }
        
        currentPage -= 1
        if currentPage < 1 {
            currentPage = 1
        }
        
        update()
    }
    
    func update() {
        centerTrainingsStatConstraint.isActive = currentPage == 1
        centerCommandsStatConstraint.isActive = currentPage == 2
        centerGamesStatConstraint.isActive = currentPage == 3
        
        widthPage1Constraint.constant = (currentPage == 1) ? 20.scale : 6.scale
        widthPage2Constraint.constant = (currentPage == 2) ? 20.scale : 6.scale
        widthPage3Constraint.constant = (currentPage == 3) ? 20.scale : 6.scale
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.page1.backgroundColor = (self.currentPage == 1) ? Appearance.black : Appearance.black.withAlphaComponent(0.4)
            self.page2.backgroundColor = (self.currentPage == 2) ? Appearance.black : Appearance.black.withAlphaComponent(0.4)
            self.page3.backgroundColor = (self.currentPage == 3) ? Appearance.black : Appearance.black.withAlphaComponent(0.4)
            
            self.layoutIfNeeded()
        }
    }
}

// MARK: Make constraints
private extension ProfileStatsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titlelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40.scale),
            titlelabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titlelabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.heightAnchor.constraint(equalToConstant: 120.scale)
        ])
        
        centerTrainingsStatConstraint = trainingsStats.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        centerCommandsStatConstraint = commandsStats.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        centerGamesStatConstraint = gamesStats.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        NSLayoutConstraint.activate([
            centerTrainingsStatConstraint,
            trainingsStats.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            commandsStats.leadingAnchor.constraint(equalTo: trainingsStats.trailingAnchor, constant: 10.scale),
            commandsStats.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            gamesStats.leadingAnchor.constraint(equalTo: commandsStats.trailingAnchor, constant: 10.scale),
            gamesStats.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pageContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            pageContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        widthPage1Constraint = page1.widthAnchor.constraint(equalToConstant: 20.scale)
        NSLayoutConstraint.activate([
            widthPage1Constraint,
            page1.leadingAnchor.constraint(equalTo: pageContainer.leadingAnchor),
            page1.topAnchor.constraint(equalTo: pageContainer.topAnchor),
            page1.bottomAnchor.constraint(equalTo: pageContainer.bottomAnchor),
            page1.heightAnchor.constraint(equalToConstant: 6.scale)
        ])
        
        widthPage2Constraint = page2.widthAnchor.constraint(equalToConstant: 6.scale)
        NSLayoutConstraint.activate([
            widthPage2Constraint,
            page2.heightAnchor.constraint(equalTo: page1.heightAnchor),
            page2.leadingAnchor.constraint(equalTo: page1.trailingAnchor, constant: 5.scale),
            page2.topAnchor.constraint(equalTo: pageContainer.topAnchor),
            page2.bottomAnchor.constraint(equalTo: pageContainer.bottomAnchor)
        ])
        
        widthPage3Constraint = page3.widthAnchor.constraint(equalToConstant: 6.scale)
        NSLayoutConstraint.activate([
            widthPage3Constraint,
            page3.heightAnchor.constraint(equalTo: page2.heightAnchor),
            page3.leadingAnchor.constraint(equalTo: page2.trailingAnchor, constant: 5.scale),
            page3.trailingAnchor.constraint(equalTo: pageContainer.trailingAnchor),
            page3.topAnchor.constraint(equalTo: pageContainer.topAnchor),
            page3.bottomAnchor.constraint(equalTo: pageContainer.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileStatsCell {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 20.scale))
            .lineHeight(24.scale)
            .textColor(Appearance.black)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Profile.StatsTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeStatsView() -> ProfileMainStatsView {
        let view = ProfileMainStatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeContainer() -> ProfileMainScrollContainerView {
        let view = ProfileMainScrollContainerView()
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePage(color: UIColor) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 3.scale
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        pageContainer.addSubview(view)
        return view
    }
    
    func makePageContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
