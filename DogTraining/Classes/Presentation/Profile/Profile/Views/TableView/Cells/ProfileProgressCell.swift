//
//  ProfileProgressCell.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import UIKit

final class ProfileProgressCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var progressView = makeProgressView()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.semiBold(size: 20.scale))
        .lineHeight(24.scale)
        .textAlignment(.center)
    
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
extension ProfileProgressCell {
    func setup(percent: Int, level: String) {
        progressView.setup(percent: percent)
        titleLabel.attributedText = String(format: "Profile.Level".localized, level).attributed(with: titleAttrs)
    }
}

// MARK: Private
private extension ProfileProgressCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ProfileProgressCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40.scale),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -156.scale),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale),
            progressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileProgressCell {
    func makeProgressView() -> ProfileMainProgressView {
        let view = ProfileMainProgressView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
