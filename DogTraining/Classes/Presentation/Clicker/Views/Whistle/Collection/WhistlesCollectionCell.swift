//
//  WhistlesCollectionCell.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 23.08.2023.
//

import UIKit

final class WhistlesCollectionCell: UICollectionViewCell {
    lazy var placeholderView = makePlaceholderView()
    lazy var innerView = makeInnerView()
    lazy var label = makeLabel()
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(Appearance.primary)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .textAlignment(.center)
        .lineHeight(25.6.scale)
    private lazy var deselectedAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.regular(size: 16.scale))
        .textAlignment(.center)
        .lineHeight(25.6.scale)
    
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
extension WhistlesCollectionCell {
    func setup(element: WhistlesCollectionElement) {
        let attrs = element.selected ? selectedAttrs : deselectedAttrs
        label.attributedText = element.name.attributed(with: attrs)
        
        placeholderView.backgroundColor = element.selected ? UIColor.clear : UIColor(integralRed: 233, green: 225, blue: 217)
        placeholderView.layer.borderWidth = element.selected ? 2.scale : 0
        placeholderView.layer.borderColor = element.selected ? Appearance.primary.cgColor : UIColor.clear.cgColor
        
        innerView.isHidden = !element.selected
    }
}

// MARK: Private
private extension WhistlesCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WhistlesCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.widthAnchor.constraint(equalToConstant: 92.scale),
            placeholderView.heightAnchor.constraint(equalToConstant: 92.scale),
            placeholderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            placeholderView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            innerView.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor, constant: 6.scale),
            innerView.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor, constant: -6.scale),
            innerView.topAnchor.constraint(equalTo: placeholderView.topAnchor, constant: 6.scale),
            innerView.bottomAnchor.constraint(equalTo: placeholderView.bottomAnchor, constant: -6.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WhistlesCollectionCell {
    func makePlaceholderView() -> CircleView {
        let view = CircleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeInnerView() -> CircleView {
        let view = CircleView()
        view.backgroundColor = Appearance.primary
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
