//
//  RepeatModeButton.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 29.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class RepeatModeButton: UIView {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    let mode: EventRepeatMode
    
    lazy var label = makeLabel()
    
    private let tapGesture = UITapGestureRecognizer()
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.bold(size: 24.scale))
        .lineHeight(28.8.scale)
        .letterSpacing(-0.44.scale)
        .textAlignment(.center)
    private lazy var deselectedAttrs = TextAttributes()
        .textColor(Appearance.black.withAlphaComponent(0.4))
        .font(Fonts.Inter.bold(size: 22.scale))
        .lineHeight(26.4.scale)
        .letterSpacing(-0.44.scale)
        .textAlignment(.center)
    
    init(mode: EventRepeatMode) {
        self.mode = mode
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RepeatModeButton {
    var didTap: Signal<EventRepeatMode> {
        tapGesture.rx.event
            .compactMap { [weak self] event in self?.mode }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension RepeatModeButton {
    func initialize() {
        layer.cornerRadius = 4.scale
        
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    func update() {
        let attrs = marked ? selectedAttrs : deselectedAttrs
        label.attributedText = mode.title.attributed(with: attrs)
        
        backgroundColor = marked ? UIColor(integralRed: 233, green: 225, blue: 217) : UIColor.clear
    }
}

// MARK: Make constraints
private extension RepeatModeButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RepeatModeButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
