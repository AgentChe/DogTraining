//
//  MakeWhistleView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 23.08.2023.
//

import UIKit

final class MakeWhistleView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var clickButton = makeClickButton()
    lazy var collectionView = makeCollectionView()
    
    private lazy var elements: [WhistlesCollectionElement] = [
        WhistlesCollectionElement(selected: true, number: 1),
        WhistlesCollectionElement(selected: false, number: 2),
        WhistlesCollectionElement(selected: false, number: 3),
        WhistlesCollectionElement(selected: false, number: 4),
        WhistlesCollectionElement(selected: false, number: 5)
    ]
    
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
extension MakeWhistleView {
    var selectedElement: WhistlesCollectionElement? {
        elements.first(where: { $0.selected })
    }
}

// MARK: Private
private extension MakeWhistleView {
    func initialize() {
        collectionView.setup(elements: elements, isNeedScroll: true)
    }
}

// MARK: Make constraints
private extension MakeWhistleView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            clickButton.widthAnchor.constraint(equalToConstant: 315.scale),
            clickButton.heightAnchor.constraint(equalToConstant: 247.24.scale),
            clickButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            clickButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 52.76.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 123.scale),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -48.scale : -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MakeWhistleView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.4))
            .font(Fonts.Inter.regular(size: 16.scale))
            .textAlignment(.center)
            .lineHeight(25.6.scale)
        
        let view = UILabel()
        view.attributedText = "Clicker.Whistle.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeClickButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.setImage(UIImage(named: "Clicker.Whistle.Normal"), for: .normal)
        view.setImage(UIImage(named: "Clicker.Whistle.Tapped"), for: .highlighted)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> WhistlesCollectionView {
        let layout = WhistlesCollectionLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 92.scale, height: CGFloat.zero)
        
        let view = WhistlesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
