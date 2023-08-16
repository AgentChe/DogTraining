//
//  GIDescriptionCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import UIKit

final class GIDescriptionCell: UITableViewCell {
    var didTapShowMore: (() -> Void)?
    
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.black.withAlphaComponent(0.8))
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)
    private lazy var showMoreAttrs = TextAttributes()
        .textColor(Appearance.primary)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.right)
    
    private lazy var isFull = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension GIDescriptionCell {
    func setup(element: GIDescriptionElement) {
        let string = NSMutableAttributedString()
        string.append(element.description.attributed(with: attrs))
        if !element.isFull {
            string.append("GameInstruction.ShowMore".localized.attributed(with: showMoreAttrs))
        }
        label.attributedText = string
        
        self.isFull = element.isFull
    }
}

// MARK: Private
private extension GIDescriptionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didTapLabel(sender: UITapGestureRecognizer) {
        guard
            !isFull,
            let label = sender.view as? UILabel,
            let text = label.text as NSString?
        else {
            return
        }
        
        let showMoreRange = text.range(of: "GameInstruction.ShowMore".localized)
        
        if sender.didTapAttributedTextInLabel(label: label, inRange: showMoreRange) {
            didTapShowMore?()
        }
    }
}

// MARK: Make constraints
private extension GIDescriptionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension GIDescriptionCell {
    func makeLabel() -> UILabel {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(sender:)))
        
        let view = UILabel()
        view.numberOfLines = 0
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
