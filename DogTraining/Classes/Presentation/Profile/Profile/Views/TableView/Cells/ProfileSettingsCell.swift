//
//  ProfileSettingsCell.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import UIKit

final class ProfileSettingsCell: UITableViewCell {
    lazy var iconView = makeIconView()
    lazy var titleLabel = makeTitleLabel()
    lazy var chevroneView = makeChevronView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
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
extension ProfileSettingsCell {
    func setup(element: String) {
        titleLabel.attributedText = String(format: "Profile.Settings".localized, element).attributed(with: attrs)
    }
}

// MARK: Private
private extension ProfileSettingsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ProfileSettingsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 40.scale),
            iconView.widthAnchor.constraint(equalToConstant: 40.scale),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 64.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            chevroneView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            chevroneView.heightAnchor.constraint(equalToConstant: 24.scale),
            chevroneView.widthAnchor.constraint(equalToConstant: 24.scale),
            chevroneView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileSettingsCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Profile.Settings")
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeChevronView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Profile.ChevronRight")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
