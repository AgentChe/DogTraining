//
//  OCommandsTableCell.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 14.08.2023.
//

import UIKit

final class OCommandsTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    lazy var checkedView = makeCheckedView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)
    
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
extension OCommandsTableCell {
    func setup(element: OCommandsTableElement) {
        label.attributedText = element.command.name.attributed(with: attrs)
        
        container.layer.borderColor = element.marked ? Appearance.primary.cgColor : UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        checkedView.isHidden = !element.marked
    }
}

// MARK: Private
private extension OCommandsTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension OCommandsTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -48.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 27.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -27.scale)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            checkedView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OCommandsTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Onboarding.Checked")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
