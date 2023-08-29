//
//  ProfileEventCell.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 29.08.2023.
//

import UIKit

final class ProfileEventCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var imageContainer = makeImageContainer()
    lazy var typeImageView = makeImageView()
    lazy var eventsTitleLabel = makeEventsTitleLabel()
    lazy var typeLabel = makeLabel()
    lazy var dateLabel = makeLabel()
    
    private lazy var typeAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.bold(size: 16.scale))
        .lineHeight(19.scale)
        .textAlignment(.left)
    private lazy var dateAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.regular(size: 14.scale))
        .lineHeight(18.2.scale)
        .textAlignment(.left)
    
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
extension ProfileEventCell {
    func setup(element: Event) {
        let data = data(for: element.type)
        typeImageView.image = data.1
        typeLabel.attributedText = data.0.attributed(with: typeAttrs)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy HH:mm"
        dateLabel.attributedText = formatter.string(from: element.date).attributed(with: dateAttrs)
    }
}

// MARK: Private
private extension ProfileEventCell {
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
private extension ProfileEventCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 112.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageContainer.widthAnchor.constraint(equalToConstant: 80.scale),
            imageContainer.heightAnchor.constraint(equalToConstant: 80.scale),
            imageContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            imageContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            typeImageView.widthAnchor.constraint(equalToConstant: 40.scale),
            typeImageView.heightAnchor.constraint(equalToConstant: 40.scale),
            typeImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            typeImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            eventsTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 112.scale),
            eventsTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            eventsTitleLabel.bottomAnchor.constraint(equalTo: typeLabel.topAnchor, constant: -5.scale)
        ])
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 112.scale),
            typeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            typeLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 112.scale),
            dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            dateLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileEventCell {
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
    
    func makeImageContainer() -> CircleView {
        let view = CircleView()
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(view)
        return view
    }
    
    func makeEventsTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.primary)
            .font(Fonts.Inter.semiBold(size: 12.scale))
            .lineHeight(15.6.scale)
            .letterSpacing(0.41.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Profile.Events.TItle".localized.attributed(with: attrs)
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
