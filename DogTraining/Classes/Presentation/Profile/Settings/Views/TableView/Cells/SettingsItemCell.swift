//
//  SettingsItemCell.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import UIKit

final class SettingsItemCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var subtitleLabel = makeLabel()
    lazy var chevroneView = makeChevron()
    lazy var lineView = makeLineView()
    
    private lazy var titleAttrs = TextAttributes()
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textColor(Appearance.black)
        .textAlignment(.left)
    private lazy var subtitleAttrs = TextAttributes()
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textColor(Appearance.black.withAlphaComponent(0.7))
        .textAlignment(.right)
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
extension SettingsItemCell {
    func setup(type: SettingsTableElement.CellType, isLast: Bool, subtitle: String?) {
        lineView.isHidden = isLast
        titleLabel.attributedText = type.title.attributed(with: titleAttrs)
        subtitleLabel.attributedText = subtitle?.attributed(with: subtitleAttrs)
    }
}

// MARK: Private
private extension SettingsItemCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}

// MARK: Make constraints
private extension SettingsItemCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
        ])
        
        NSLayoutConstraint.activate([
            chevroneView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevroneView.heightAnchor.constraint(equalToConstant: 24.scale),
            chevroneView.widthAnchor.constraint(equalTo: chevroneView.heightAnchor),
            chevroneView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: chevroneView.leadingAnchor, constant: -10.scale),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1.scale),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsItemCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeChevron() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Profile.ChevronRight")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLineView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(integralRed: 223, green: 225, blue: 217)
        contentView.addSubview(view)
        return view
    }
}

// MARK: Additional
private extension SettingsTableElement.CellType {
    var title: String {
        switch self {
        case .skillLevel:
            return "Profile.SkillLevel".localized
        case .trainingDays:
            return "Profile.TrainingDays".localized
        case .commandsGroups:
            return "Profile.CommandsGroups".localized
        case .dogName:
            return "Profile.DogName".localized
        case .termsOfUse:
            return "Profile.TermsofUse".localized
        case .privatePolicy:
            return "Profile.PrivacyPolicy".localized
        case .contactUs:
            return "Profile.ContactUs".localized
        }
    }
}
