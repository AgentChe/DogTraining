//
//  OTopicsView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 14.08.2023.
//

import UIKit

final class OTopicsView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var topic1Button = makeTopicButton(number: 1)
    lazy var topic2Button = makeTopicButton(number: 2)
    lazy var topic3Button = makeTopicButton(number: 3)
    lazy var topic4Button = makeTopicButton(number: 4)
    lazy var topic5Button = makeTopicButton(number: 5)
    lazy var continueButton = makeContinueButton()
    
    private lazy var topicsButtons = [
        topic1Button,
        topic2Button,
        topic3Button,
        topic4Button,
        topic5Button
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
private extension OTopicsView {
    func initialize() {
        backgroundColor = Appearance.background
        
        continueButton(enable: false)
    }
    
    @objc
    func didTapTopic(sender: UIButton) {
        setupDefaultBorders()
        
        sender.layer.borderColor = Appearance.primary.cgColor
        
        continueButton(enable: true)
    }
    
    func setupDefaultBorders() {
        topicsButtons.forEach {
            $0.layer.borderColor = UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        }
    }
    
    func continueButton(enable: Bool) {
        continueButton.isEnabled = enable
        continueButton.alpha = enable ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension OTopicsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 52.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            topic1Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            topic1Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            topic1Button.heightAnchor.constraint(equalToConstant: 80.scale),
            topic1Button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            topic2Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            topic2Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            topic2Button.heightAnchor.constraint(equalToConstant: 80.scale),
            topic2Button.topAnchor.constraint(equalTo: topic1Button.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            topic3Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            topic3Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            topic3Button.heightAnchor.constraint(equalToConstant: 80.scale),
            topic3Button.topAnchor.constraint(equalTo: topic2Button.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            topic4Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            topic4Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            topic4Button.heightAnchor.constraint(equalToConstant: 80.scale),
            topic4Button.topAnchor.constraint(equalTo: topic3Button.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            topic5Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            topic5Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            topic5Button.heightAnchor.constraint(equalToConstant: 80.scale),
            topic5Button.topAnchor.constraint(equalTo: topic4Button.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 8.scale)
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
private extension OTopicsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Topics.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTopicButton(number: Int) -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.regular(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Onboarding.Topics.\(number)".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.backgroundColor = Appearance.white
        view.addTarget(self, action: #selector(didTapTopic(sender:)), for: .touchUpInside)
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
