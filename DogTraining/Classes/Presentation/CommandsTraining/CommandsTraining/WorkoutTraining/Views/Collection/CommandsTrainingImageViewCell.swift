//
//  CommandsTrainingImageViewCell.swift
//  Soccer
//
//  Created by Виталий Загороднов on 04.04.2023.
//

import UIKit
import Kingfisher

final class CommandsTrainingImageViewCell: UICollectionViewCell {
    lazy var imageView = makeImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}

// MARK: Public
extension CommandsTrainingImageViewCell {
    func setup(element: Command) {
        imageView.kf.setImage(with: element.image)
    }
}

// MARK: Private
private extension CommandsTrainingImageViewCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension CommandsTrainingImageViewCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CommandsTrainingImageViewCell {
    func makeImageView() -> GameTrainingBackgroundImageView {
        let view = GameTrainingBackgroundImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
