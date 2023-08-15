//
//  HomeCommandsGroupsCollectionCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit

final class HomeCommandsGroupsCollectionCell: UICollectionViewCell {
    lazy var label = makeLabel()
    
    private static let attrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)
    
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
extension HomeCommandsGroupsCollectionCell {
    static func size(for commandGroup: CommandGroup) -> CGSize {
        let size = commandGroup.name.attributed(with: HomeCommandsGroupsCollectionCell.attrs).size()
        return CGSize(width: size.width + 32.scale, height: size.height + 20.scale)
    }
    
    func setup(element: CommandGroup) {
        label.attributedText = element.name.attributed(with: HomeCommandsGroupsCollectionCell.attrs)
    }
}

// MARK: Private
private extension HomeCommandsGroupsCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension HomeCommandsGroupsCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeCommandsGroupsCollectionCell {
    func makeLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.insets = UIEdgeInsets(top: 10.scale, left: 16.scale, bottom: 10.scale, right: 16.scale)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        view.layer.borderWidth = 1.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
