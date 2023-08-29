//
//  SelectView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 28.08.2023.
//

import UIKit

final class SelectView: UIButton {
    lazy var headerLabel = makeTitleLabel()
    lazy var valueLabel = makeValueLabel()
    
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.primary)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.right)
    
    private let title: String
    
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SelectView {
    func setup(value: String) {
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
}

// MARK: Make constraints
private extension SelectView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            valueLabel.leadingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: 8.scale),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SelectView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.4))
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(25.6.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.isUserInteractionEnabled = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.isUserInteractionEnabled = false
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
