//
//  TrainArticleCell.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 21.08.2023.
//

import UIKit
import Kingfisher

final class TrainArticleCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var pictureView = makeImageView()
    lazy var label = makeLabel()
    lazy var arrowView = makeArrowView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(20.8.scale)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
    }
}

// MARK: Public
extension TrainArticleCell {
    func setup(element: Article) {
        pictureView.kf.setImage(with: element.image)
        
        label.attributedText = element.title.attributed(with: attrs)
    }
}

// MARK: Private
private extension TrainArticleCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TrainArticleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            container.heightAnchor.constraint(equalToConstant: 90.scale)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 90.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 90.scale),
            pictureView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            pictureView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 122.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -56.scale),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 32.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 32.scale),
            arrowView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            arrowView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TrainArticleCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
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
        view.numberOfLines = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Articles.Arrow")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
