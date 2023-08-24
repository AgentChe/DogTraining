//
//  ClickerView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 23.08.2023.
//

import UIKit

final class ClickerView: UIView {
    lazy var unitView = makeUnitView()
    lazy var whistleView = makeWhistleView()
    lazy var clickerView = makeClickerView()
    
    private lazy var whistleTrailingConstraint = NSLayoutConstraint()
    private lazy var clickerLeadingConstraint = NSLayoutConstraint()
    
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
extension ClickerView {
    func move(to unit: ClickerUnitView.Unit) {
        NSLayoutConstraint.deactivate([
            whistleTrailingConstraint,
            clickerLeadingConstraint
        ])
        
        switch unit {
        case .whistle:
            whistleTrailingConstraint = whistleView.trailingAnchor.constraint(equalTo: trailingAnchor)
            clickerLeadingConstraint = clickerView.leadingAnchor.constraint(equalTo: trailingAnchor)
        case .clicker:
            whistleTrailingConstraint = whistleView.trailingAnchor.constraint(equalTo: leadingAnchor)
            clickerLeadingConstraint = clickerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        }
        
        NSLayoutConstraint.activate([
            whistleTrailingConstraint,
            clickerLeadingConstraint
        ])
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
    }
}

// MARK: Private
private extension ClickerView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension ClickerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            unitView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            unitView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            unitView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale),
            unitView.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        whistleTrailingConstraint = whistleView.trailingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([
            whistleView.topAnchor.constraint(equalTo: unitView.bottomAnchor),
            whistleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            whistleView.widthAnchor.constraint(equalTo: widthAnchor),
            whistleTrailingConstraint
        ])
        
        clickerLeadingConstraint = clickerView.leadingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([
            clickerView.topAnchor.constraint(equalTo: unitView.bottomAnchor),
            clickerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            clickerView.widthAnchor.constraint(equalTo: widthAnchor),
            clickerLeadingConstraint
        ])
    }
}

// MARK: Lazy initialization
private extension ClickerView {
    func makeUnitView() -> ClickerUnitView {
        let view = ClickerUnitView()
        view.backgroundColor = UIColor(integralRed: 223, green: 225, blue: 217)
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWhistleView() -> MakeWhistleView {
        let view = MakeWhistleView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeClickerView() -> MakeClickerView {
        let view = MakeClickerView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
