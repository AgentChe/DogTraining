//
//  ORoleButton.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 11.08.2023.
//

import UIKit

final class ORoleButton: UIButton {
    var marked = false {
        didSet {
            update()
        }
    }
    
    let dogOwnerRole: DogOwnerRole
    
    lazy var iconView = makeIconView()
    lazy var nameLabel = makeLabel()
    
    init(dogOwnerRole: DogOwnerRole) {
        self.dogOwnerRole = dogOwnerRole
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ORoleButton {
    func update() {
        backgroundColor = marked ? Appearance.secondary : Appearance.white
        layer.borderWidth = 1.scale
        layer.borderColor = marked ? Appearance.secondary.cgColor : UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        
        iconView.image = icon
        
        let attrs = TextAttributes()
            .textColor(marked ? Appearance.white : Appearance.black)
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(25.6.scale)
            .textAlignment(.center)
        nameLabel.attributedText = name.attributed(with: attrs)
    }
    
    var icon: UIImage? {
        switch dogOwnerRole {
        case .owner:
            return UIImage(named: marked ? "Onboarding.Role.Owner.Selected" : "Onboarding.Role.Owner.Deselected")
        case .trainer:
            return UIImage(named: marked ? "Onboarding.Role.Trainer.Selected" : "Onboarding.Role.Trainer.Deselected")
        case .sitter:
            return UIImage(named: marked ? "Onboarding.Role.Sitter.Selected" : "Onboarding.Role.Sitter.Deselected")
        }
    }
    
    var name: String {
        switch dogOwnerRole {
        case .owner:
            return "Onboarding.Role.Owner".localized
        case .trainer:
            return "Onboarding.Role.Trainer".localized
        case .sitter:
            return "Onboarding.Role.Sitter".localized
        }
    }
}

// MARK: Make constraints
private extension ORoleButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 89.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6.scale),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ORoleButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
