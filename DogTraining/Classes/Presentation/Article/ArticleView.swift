//
//  ArticleView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 22.08.2023.
//

import UIKit
import Kingfisher

final class ArticleView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeLabel()
    lazy var contentLabel = makeLabel()
    lazy var preloader = makePreloader()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.bold(size: 24.scale))
        .lineHeight(28.8.scale)
        .textAlignment(.left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ArticleView {
    func setup(articleDetails: ArticleDetails) {
        imageView.kf.setImage(with: articleDetails.image)
        
        titleLabel.attributedText = articleDetails.title.attributed(with: titleAttrs)
        
        contentLabel.attributedText = attributedString(for: articleDetails.content)
    }
}

// MARK: Private
private extension ArticleView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    func attributedString(for htmlString: String) -> NSAttributedString? {
        guard !htmlString.isEmpty else {
            return nil
        }
        
        let font = Fonts.Inter.regular(size: 16.scale)
        let htmlWithStyle = "<span style=\"font-family: \(font.fontName); font-style: semiBold; font-size: \(font.pointSize); line-height: \(25.6.scale)px;\">\(htmlString)</span>"
        let data = Data(htmlWithStyle.utf8)
        
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        
        return attributedString
    }
}

// MARK: Make constraints
private extension ArticleView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            imageView.heightAnchor.constraint(equalToConstant: 234.scale),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            contentLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale),
            contentLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ArticleView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.contentInset = UIEdgeInsets.zero
        view.setContentOffset(CGPoint.zero, animated: false)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
