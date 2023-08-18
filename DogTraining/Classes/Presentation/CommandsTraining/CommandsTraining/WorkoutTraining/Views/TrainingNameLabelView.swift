//
//  TrainingNameLabelView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.03.2023.
//

import UIKit

final class TrainingNameLabelView: UIView {
    private lazy var nameLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstrains()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: Public
extension TrainingNameLabelView {
    func setup(name: String) {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(25.scale)
            .textAlignment(.center)
        nameLabel.attributedText = name.attributed(with: attrs)
    }
}

// MARK: Private
private extension TrainingNameLabelView {
    func initialize() {
        backgroundColor = Appearance.white
        layer.cornerRadius = 10.scale
        layer.borderWidth = 1
        layer.borderColor = UIColor(integralRed: 233, green: 225, blue: 217).cgColor
    }
}

// MARK: Make constraints
private extension TrainingNameLabelView {
    func makeConstrains() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TrainingNameLabelView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
