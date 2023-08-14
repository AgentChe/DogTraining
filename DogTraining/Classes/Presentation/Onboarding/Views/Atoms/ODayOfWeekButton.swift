//
//  ODayOfWeekButton.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 14.08.2023.
//

import UIKit

final class ODayOfWeekButton: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    
    let dayOfWeek: DayOfWeek
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)
    private lazy var deselectedAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)
    
    init(dayOfWeek: DayOfWeek) {
        self.dayOfWeek = dayOfWeek
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = max(frame.width, frame.height) / 2
    }
}

// MARK: Private
private extension ODayOfWeekButton {
    func update() {
        layer.borderWidth = marked ? 0 : 1.scale
        layer.borderColor = marked ? UIColor.clear.cgColor : UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        
        backgroundColor = marked ? Appearance.secondary : Appearance.white
        
        let attrs = marked ? selectedAttrs : deselectedAttrs
        label.attributedText = text.attributed(with: attrs)
    }
    
    var text: String {
        switch dayOfWeek {
        case .su:
            return "Onboarding.DaysOfWeek.Su".localized
        case .mo:
            return "Onboarding.DaysOfWeek.Mo".localized
        case .tu:
            return "Onboarding.DaysOfWeek.Tu".localized
        case .we:
            return "Onboarding.DaysOfWeek.We".localized
        case .th:
            return "Onboarding.DaysOfWeek.Th".localized
        case .fr:
            return "Onboarding.DaysOfWeek.Fr".localized
        case .sa:
            return "Onboarding.DaysOfWeek.Sa".localized
        }
    }
}

// MARK: Make constraints
private extension ODayOfWeekButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ODayOfWeekButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
