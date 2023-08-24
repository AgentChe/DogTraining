//
//  MakeClickerView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 23.08.2023.
//

import UIKit

final class MakeClickerView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var clickButton = makeClickButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension MakeClickerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            clickButton.widthAnchor.constraint(equalToConstant: 148.scale),
            clickButton.heightAnchor.constraint(equalToConstant: 307.scale),
            clickButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            clickButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 86.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MakeClickerView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.4))
            .font(Fonts.Inter.regular(size: 16.scale))
            .textAlignment(.center)
            .lineHeight(25.6.scale)
        
        let view = UILabel()
        view.attributedText = "Clicker.Clicker.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeClickButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.setImage(UIImage(named: "Clicker.Clicker.Normal"), for: .normal)
        view.setImage(UIImage(named: "Clicker.Clicker.Tapped"), for: .highlighted)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
