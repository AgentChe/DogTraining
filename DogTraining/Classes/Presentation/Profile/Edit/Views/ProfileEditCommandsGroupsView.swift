//
//  ProfileEditCommandsGroupsView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditCommandsGroupsView: UIView {
    var didSave: (([CommandGroup]) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    lazy var continueButton = makeContinueButton()
    
    private lazy var commandsManager = CommandsManager()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didTapSaveTrigger = PublishRelay<[CommandGroup]>()
    
    init(commandsGroups: [CommandGroup]) {
        super.init(frame: .zero)
        
        makeConstraints()
        initialize(commandsGroups: commandsGroups)
        checkEnable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ProfileEditCommandsGroupsView {
    func initialize(commandsGroups: [CommandGroup]) {
        backgroundColor = Appearance.background
        
        tableView.didSelect = { [weak self] in
            self?.checkEnable()
        }
        
        commandsManager
            .obtainCommandsGroups(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(tableView) { base, commands in
                let elements = commands.map { command -> OCommandsTableElement in
                    OCommandsTableElement(
                        command: command,
                        marked: commandsGroups.contains(where: { $0.id == command.id })
                    )
                }
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func didTapContinue() {
        let commandsGroups = tableView.elements.compactMap { element -> CommandGroup? in
            element.marked ? element.command : nil
        }
        didSave?(commandsGroups)
    }
    
    func checkEnable() {
        let marked = tableView.elements.contains(where: { $0.marked })
        continueButton.isEnabled = marked
        continueButton.alpha = marked ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension ProfileEditCommandsGroupsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 52.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -62.scale : -32.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileEditCommandsGroupsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Commands.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> OCommandsTableView {
        let view = OCommandsTableView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(top: 45.scale, left: 0, bottom: 16.scale, right: 0)
        view.setContentOffset(CGPoint(x: 0, y: -45.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 8.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
