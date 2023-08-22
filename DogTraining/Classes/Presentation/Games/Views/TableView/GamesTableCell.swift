//
//  GamesTableCell.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 22.08.2023.
//

import UIKit
import Kingfisher

final class GamesTableCell: UITableViewCell {
    lazy var pictureView = makeImageView()
    lazy var shadowView = makeShadowView()
    lazy var nameLabel = makeNameLabel()
    lazy var tag1Label = makeTagLabel()
    lazy var tag2Label = makeTagLabel()
    lazy var lockedView = makeLockedView()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.semiBold(size: 20.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    private lazy var tagAttrs = TextAttributes()
        .textColor(Appearance.white)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
    }
}

// MARK: Public
extension GamesTableCell {
    func setup(element: GamesTableElement) {
        pictureView.kf.setImage(with: element.game.image)
        
        nameLabel.attributedText = element.game.name.attributed(with: nameAttrs)
        
        tag1Label.attributedText = element.skillLevel.name.attributed(with: tagAttrs)
        tag2Label.attributedText = element.gamesGroup.name.attributed(with: tagAttrs)
        
        lockedView.isHidden = !element.locked
    }
}

// MARK: Private
private extension GamesTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension GamesTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            nameLabel.bottomAnchor.constraint(equalTo: tag1Label.topAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag1Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            tag1Label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag2Label.leadingAnchor.constraint(equalTo: tag1Label.trailingAnchor, constant: 10.scale),
            tag2Label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockedView.widthAnchor.constraint(equalToConstant: 36.scale),
            lockedView.heightAnchor.constraint(equalToConstant: 36.scale),
            lockedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            lockedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension GamesTableCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeShadowView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 9, green: 9, blue: 9, alpha: 0.5)
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTagLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.backgroundColor = Appearance.white.withAlphaComponent(0.2)
        view.layer.cornerRadius = 11.scale
        view.layer.masksToBounds = true
        view.insets = UIEdgeInsets(top: 4.scale, left: 8.scale, bottom: 4.scale, right: 8.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLockedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Games.Locked")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
