//
//  TTHeaderCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit
import Kingfisher

final class TTHeaderCell: UITableViewCell {
    lazy var pictureView = makeImageView()
    lazy var nameLabel = makeNameLabel()
    lazy var skillLevelLabel = makeTagLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.bold(size: 24.scale))
        .lineHeight(28.8.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    private lazy var tagAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.semiBold(size: 12.scale))
        .lineHeight(14.4.scale)
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
extension TTHeaderCell {
    func setup(element: TrainingTemplateHeaderElement) {
        pictureView.kf.setImage(with: element.image)
        
        nameLabel.attributedText = element.name.attributed(with: nameAttrs)
        skillLevelLabel.attributedText = element.skillLevel.attributed(with: tagAttrs)
    }
}

// MARK: Private
private extension TTHeaderCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TTHeaderCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pictureView.heightAnchor.constraint(equalToConstant: 264.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 16.scale),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40.scale)
        ])
        
        NSLayoutConstraint.activate([
            skillLevelLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            skillLevelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TTHeaderCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTagLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.backgroundColor = UIColor(integralRed: 233, green: 225, blue: 217)
        view.layer.cornerRadius = 11.scale
        view.layer.masksToBounds = true
        view.insets = UIEdgeInsets(top: 4.scale, left: 8.scale, bottom: 4.scale, right: 8.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
