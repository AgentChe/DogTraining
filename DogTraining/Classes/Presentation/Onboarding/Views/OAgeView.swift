//
//  OAgeView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 14.08.2023.
//

import UIKit

final class OAgeView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var age1Button = makeAgeButton(title: "Onboarding.Age.1".localized)
    lazy var age2Button = makeAgeButton(title: "Onboarding.Age.2".localized)
    lazy var age3Button = makeAgeButton(title: "Onboarding.Age.3".localized)
    lazy var age4Button = makeAgeButton(title: "Onboarding.Age.4".localized)
    lazy var age5Button = makeAgeButton(title: "Onboarding.Age.5".localized)
    lazy var continueButton = makeContinueButton()
    
    private lazy var agesButtons = [
        age1Button,
        age2Button,
        age3Button,
        age4Button,
        age5Button
    ]
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        setupDefaultBorders()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OAgeView {
    func initialize() {
        backgroundColor = Appearance.background
        
        continueButton.isHidden = true
    }
    
    @objc
    func didTapAge(sender: UIButton) {
        setupDefaultBorders()
        
        sender.layer.borderColor = Appearance.primary.cgColor
        
        continueButton.isHidden = false
    }
    
    func setupDefaultBorders() {
        agesButtons.forEach {
            $0.layer.borderColor = UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        }
    }
}

// MARK: Make constraints
private extension OAgeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            age1Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            age1Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            age1Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age1Button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            age2Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            age2Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            age2Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age2Button.topAnchor.constraint(equalTo: age1Button.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            age3Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            age3Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            age3Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age3Button.topAnchor.constraint(equalTo: age2Button.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            age4Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            age4Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            age4Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age4Button.topAnchor.constraint(equalTo: age3Button.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            age5Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            age5Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            age5Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age5Button.topAnchor.constraint(equalTo: age4Button.bottomAnchor, constant: 16.scale)
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
private extension OAgeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Age.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAgeButton(title: String) -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.regular(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle(title.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.addTarget(self, action: #selector(didTapAge(sender:)), for: .touchUpInside)
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
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
