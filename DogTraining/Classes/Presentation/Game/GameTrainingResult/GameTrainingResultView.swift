//
//  GameTrainingResultView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit
import Kingfisher

final class GameTrainingResultView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var gameContainer = makeGameContainer()
    lazy var imageView = makeImageView()
    lazy var nameLabel = makeNameLabel()
    lazy var skillLevelLabel = makeTagLabel()
    lazy var gameCategoryLabel = makeTagLabel()
    lazy var durationTitleLabel = makeDurationTitleLabel()
    lazy var durationLabel = makeDurationLabel()
    lazy var continueButton = makeContinueButton()
    
    private lazy var tagAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.semiBold(size: 12.scale))
        .lineHeight(14.4.scale)
        .textAlignment(.center)
    
    private let gameTraining: GameTraining
    
    init(gameTraining: GameTraining) {
        self.gameTraining = gameTraining
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
extension GameTrainingResultView {
    func setup(skillLevel: SkillLevel) {
        skillLevelLabel.attributedText = skillLevel.name.attributed(with: tagAttrs)
    }
    
    func setup(gameGroup: GameGroup) {
        gameCategoryLabel.attributedText = gameGroup.name.attributed(with: tagAttrs)
    }
}

// MARK: Private
private extension GameTrainingResultView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension GameTrainingResultView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 60.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gameContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            gameContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            gameContainer.heightAnchor.constraint(equalToConstant: 377.scale),
            gameContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 34.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 237.scale),
            imageView.heightAnchor.constraint(equalToConstant: 254.scale),
            imageView.centerXAnchor.constraint(equalTo: gameContainer.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: gameContainer.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: gameContainer.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: gameContainer.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            skillLevelLabel.trailingAnchor.constraint(equalTo: gameContainer.centerXAnchor, constant: -5.scale),
            skillLevelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            gameCategoryLabel.leadingAnchor.constraint(equalTo: gameContainer.centerXAnchor, constant: 5.scale),
            gameCategoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            durationTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            durationTitleLabel.topAnchor.constraint(equalTo: gameContainer.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            durationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            durationLabel.topAnchor.constraint(equalTo: durationTitleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension GameTrainingResultView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "GameTrainingResult.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.2.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "GameTrainingResult.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGameContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.kf.setImage(with: gameTraining.game.image)
        view.translatesAutoresizingMaskIntoConstraints = false
        gameContainer.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.semiBold(size: 20.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = gameTraining.game.name.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        gameContainer.addSubview(view)
        return view
    }
    
    func makeTagLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.backgroundColor = UIColor(integralRed: 242, green: 237, blue: 232)
        view.layer.cornerRadius = 11.scale
        view.layer.masksToBounds = true
        view.insets = UIEdgeInsets(top: 4.scale, left: 8.scale, bottom: 4.scale, right: 8.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        gameContainer.addSubview(view)
        return view
    }
    
    func makeDurationTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.2.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "GameTrainingResult.Duration".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDurationLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.primary)
            .font(Fonts.Inter.bold(size: 32.scale))
            .lineHeight(38.4.scale)
            .textAlignment(.center)
        
        let seconds = gameTraining.assignedGame.trainedTime
        var mins = 0
        var secs = seconds
        if seconds >= 60 {
            mins = Int(seconds / 60)
            secs = seconds - (mins * 60)
        }
        let string = String(format: "%02d:%02d", mins, secs)
        
        let view = UILabel()
        view.attributedText = string.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 8.scale
        view.backgroundColor = Appearance.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
