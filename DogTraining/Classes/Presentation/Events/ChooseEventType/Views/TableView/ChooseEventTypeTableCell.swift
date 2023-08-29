//
//  ChooseEventTypeTableCell.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 28.08.2023.
//

import UIKit

final class ChooseEventTypeTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ChooseEventTypeTableCell {
    func setup(element: EventType) {
        let (string, image) = data(for: element)
        
        iconView.image = image
        label.attributedText = string.attributed(with: attrs)
    }
}

// MARK: Private
private extension ChooseEventTypeTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func data(for type: EventType) -> (String, UIImage?) {
        let key: String
        
        switch type {
        case .vaccination:
            key = "EventType.Vaccination"
        case .antiParasitic:
            key = "EventType.AntiParasitic"
        case .medicine:
            key = "EventType.Medicine"
        case .symptoms:
            key = "EventType.Symptoms"
        case .vetVisit:
            key = "EventType.VetVisit"
        case .care:
            key = "EventType.Care"
        case .other:
            key = "EventType.Other"
        }
        
        return (
            key.localized,
            UIImage(named: key)
        )
    }
}

// MARK: Make constraints
private extension ChooseEventTypeTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            container.heightAnchor.constraint(equalToConstant: 80.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 40.scale),
            iconView.heightAnchor.constraint(equalToConstant: 40.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 72.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ChooseEventTypeTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        view.backgroundColor = Appearance.white
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
