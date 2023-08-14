//
//  OWhereTrainButton.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 14.08.2023.
//

import UIKit

final class OWhereTrainButton: UIButton {
    var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var iconView = makeIconView()
    lazy var nameLabel = makeLabel()
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)
    private lazy var deselectedAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)
    
    private let iconName: String
    private let name: String
    
    init(iconName: String, name: String) {
        self.iconName = iconName
        self.name = name
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OWhereTrainButton {
    func update() {
        backgroundColor = marked ? Appearance.secondary : Appearance.white
        layer.borderWidth = marked ? 0 : 1.scale
        layer.borderColor = marked ? UIColor.clear.cgColor : UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        
        let additional = marked ? ".Selected" : ".Deselected"
        iconView.image = UIImage(named: iconName + additional)
        
        let attrs = marked ? selectedAttrs : deselectedAttrs
        nameLabel.attributedText = name.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension OWhereTrainButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 142.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OWhereTrainButton {
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
