//
//  OBehaviorView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 14.08.2023.
//

import UIKit

final class OBehaviorView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var scrollView = makeScrollView()
    lazy var behaviorButton1 = makeBehaviorButton(number: 1)
    lazy var behaviorButton2 = makeBehaviorButton(number: 2)
    lazy var behaviorButton3 = makeBehaviorButton(number: 3)
    lazy var behaviorButton4 = makeBehaviorButton(number: 4)
    lazy var behaviorButton5 = makeBehaviorButton(number: 5)
    lazy var behaviorButton6 = makeBehaviorButton(number: 6)
    lazy var continueButton = makeContinueButton()
    
    private lazy var behaviorsButtons = [
        behaviorButton1,
        behaviorButton2,
        behaviorButton3,
        behaviorButton4,
        behaviorButton5,
        behaviorButton6
    ]
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        checkEnable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OBehaviorView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    @objc
    func didTapBehavior(sender: UIButton) {
        guard let behaviorButton = sender as? OBehaviorButton else {
            return
        }
        
        behaviorButton.marked.toggle()
        
        checkEnable()
    }
    
    func checkEnable() {
        let marked = behaviorsButtons.contains(where: { $0.marked })
        continueButton.isHidden = !marked
    }
}

// MARK: Make constraints
private extension OBehaviorView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            behaviorButton1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            behaviorButton1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            behaviorButton1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            behaviorButton1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            behaviorButton1.heightAnchor.constraint(equalToConstant: 80.scale),
            behaviorButton1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            behaviorButton2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            behaviorButton2.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            behaviorButton2.heightAnchor.constraint(equalToConstant: 80.scale),
            behaviorButton2.topAnchor.constraint(equalTo: behaviorButton1.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            behaviorButton3.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            behaviorButton3.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            behaviorButton3.heightAnchor.constraint(equalToConstant: 80.scale),
            behaviorButton3.topAnchor.constraint(equalTo: behaviorButton2.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            behaviorButton4.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            behaviorButton4.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            behaviorButton4.heightAnchor.constraint(equalToConstant: 80.scale),
            behaviorButton4.topAnchor.constraint(equalTo: behaviorButton3.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            behaviorButton5.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            behaviorButton5.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            behaviorButton5.heightAnchor.constraint(equalToConstant: 80.scale),
            behaviorButton5.topAnchor.constraint(equalTo: behaviorButton4.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            behaviorButton6.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            behaviorButton6.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            behaviorButton6.heightAnchor.constraint(equalToConstant: 80.scale),
            behaviorButton6.topAnchor.constraint(equalTo: behaviorButton5.bottomAnchor, constant: 16.scale),
            behaviorButton6.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16.scale)
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
private extension OBehaviorView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Behavior.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.contentInset = UIEdgeInsets.zero
        view.setContentOffset(CGPoint.zero, animated: false)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBehaviorButton(number: Int) -> OBehaviorButton {
        let view = OBehaviorButton(number: number)
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.backgroundColor = Appearance.white
        view.addTarget(self, action: #selector(didTapBehavior(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
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
