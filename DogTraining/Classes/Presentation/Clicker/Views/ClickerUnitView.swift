//
//  ClickerUnitView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 23.08.2023.
//

import UIKit

final class ClickerUnitView: UIView {
    enum Unit {
        case whistle, clicker
    }
    
    lazy var unit = Unit.whistle {
        didSet {
            update(animate: true)
        }
    }
    
    lazy var selector = makeSelector()
    lazy var whistleButton = makeButton()
    lazy var clickerButton = makeButton()
    
    private lazy var selectorLeadingConstraint = NSLayoutConstraint()
    private lazy var selectorTrailingConstraint = NSLayoutConstraint()
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.medium(size: 16.scale))
    private lazy var deselectedAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.medium(size: 16.scale))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update(animate: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ClickerUnitView {
    func update(animate: Bool) {
        NSLayoutConstraint.deactivate([
            selectorLeadingConstraint,
            selectorTrailingConstraint
        ])
        
        switch unit {
        case .whistle:
            selectorLeadingConstraint = selector.leadingAnchor.constraint(equalTo: leadingAnchor)
            selectorTrailingConstraint = selector.trailingAnchor.constraint(equalTo: centerXAnchor)
        case .clicker:
            selectorLeadingConstraint = selector.leadingAnchor.constraint(equalTo: centerXAnchor)
            selectorTrailingConstraint = selector.trailingAnchor.constraint(equalTo: trailingAnchor)
        }
        
        NSLayoutConstraint.activate([
            selectorLeadingConstraint,
            selectorTrailingConstraint
        ])
        
        if animate {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.updateTitles()
                self?.layoutIfNeeded()
            })
        } else {
            updateTitles()
            layoutIfNeeded()
        }
    }
    
    func updateTitles() {
        whistleButton.setAttributedTitle("Clicker.Filter.Whistle".localized.attributed(with: unit == .whistle ? selectedAttrs : deselectedAttrs), for: .normal)
        clickerButton.setAttributedTitle("Clicker.Filter.Clicker".localized.attributed(with: unit == .clicker ? selectedAttrs : deselectedAttrs), for: .normal)
    }
}

// MARK: Make constraints
private extension ClickerUnitView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            selector.topAnchor.constraint(equalTo: topAnchor),
            selector.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            whistleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            whistleButton.trailingAnchor.constraint(equalTo: centerXAnchor),
            whistleButton.topAnchor.constraint(equalTo: topAnchor),
            whistleButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clickerButton.leadingAnchor.constraint(equalTo: centerXAnchor),
            clickerButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            clickerButton.topAnchor.constraint(equalTo: topAnchor),
            clickerButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ClickerUnitView {
    func makeSelector() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
