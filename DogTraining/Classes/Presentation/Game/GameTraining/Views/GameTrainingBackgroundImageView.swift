//
//  GameTrainingBackgroundImageView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit
import Kingfisher

final class GameTrainingBackgroundImageView: UIImageView {
    lazy var shadowView = makeShadowView()
    lazy var gradientView = makeGradientView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension GameTrainingBackgroundImageView {
    func setup(image: URL) {
        kf.setImage(with: image)
    }
}

// MARK: Make constraints
private extension GameTrainingBackgroundImageView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: centerYAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension GameTrainingBackgroundImageView {
    func makeShadowView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.background.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGradientView() -> GradientView {
        let view = GradientView()
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.colors = [
            UIColor(integralRed: 242, green: 237, blue: 232, alpha: 0).cgColor,
            UIColor(integralRed: 242, green: 237, blue: 232).cgColor,
            UIColor(integralRed: 242, green: 237, blue: 232).cgColor
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
