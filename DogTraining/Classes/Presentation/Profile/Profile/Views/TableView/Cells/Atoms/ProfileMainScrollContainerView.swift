//
//  ProfileMainScrollContainerView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import UIKit

final class ProfileMainScrollContainerView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let color = Appearance.background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            color.cgColor,
            color.cgColor,
            color.withAlphaComponent(0).cgColor,
            color.withAlphaComponent(0).cgColor,
            color.cgColor,
            color.cgColor
        ]
        gradientLayer.locations = [0, 0.1, 0.3, 0.7, 0.9, 1]
        gradientLayer.startPoint = .init(x: 0, y: 0.5)
        gradientLayer.endPoint = .init(x: 1, y: 0.5)
        gradientLayer.frame = rect
        layer.addSublayer(gradientLayer)
    }
}
