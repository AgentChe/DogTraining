//
//  ORoleView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 11.08.2023.
//

import UIKit

final class ORoleView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var ownerButton = makeRoleButton(role: .owner)
    lazy var trainerButton = makeRoleButton(role: .trainer)
    lazy var sitterButton = makeRoleButton(role: .sitter)
    lazy var continueButton = makeContinueButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        checkEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ORoleView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    @objc
    func tapped(sender: UIButton) {
        guard let roleButton = sender as? ORoleButton else {
            return
        }
        
        [ownerButton, trainerButton, sitterButton].forEach { $0.marked = false }
        roleButton.marked = true
        
        checkEnabled()
    }
    
    func checkEnabled() {
        let marked = [ownerButton, trainerButton, sitterButton].contains(where: { $0.marked })
        continueButton.isHidden = !marked
    }
}

// MARK: Make constraints
private extension ORoleView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 140.scale : 52.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ownerButton.widthAnchor.constraint(equalToConstant: 103.scale),
            ownerButton.heightAnchor.constraint(equalToConstant: 121.scale),
            ownerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23.scale),
            ownerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 140.scale : 140.scale)
        ])
        
        NSLayoutConstraint.activate([
            trainerButton.widthAnchor.constraint(equalToConstant: 103.scale),
            trainerButton.heightAnchor.constraint(equalToConstant: 121.scale),
            trainerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 136.scale),
            trainerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 140.scale : 140.scale)
        ])
        
        NSLayoutConstraint.activate([
            sitterButton.widthAnchor.constraint(equalToConstant: 103.scale),
            sitterButton.heightAnchor.constraint(equalToConstant: 121.scale),
            sitterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 249.scale),
            sitterButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 140.scale : 140.scale)
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
private extension ORoleView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Role.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRoleButton(role: DogOwnerRole) -> ORoleButton {
        let view = ORoleButton(dogOwnerRole: role)
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
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
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
