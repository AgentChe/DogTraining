//
//  RepeatModeView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 29.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class RepeatModeView: UIView {
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var buttonsContainer = makeButtonsContainer()
    lazy var neverModeButton = makeModeButton(mode: .never)
    lazy var dailyModeButton = makeModeButton(mode: .daily)
    lazy var weeklyModeButton = makeModeButton(mode: .weekly)
    lazy var monthlyModeButton = makeModeButton(mode: .monthly)
    lazy var yearlyModeButton = makeModeButton(mode: .yearly)
    lazy var saveButton = makeSaveButton()
    
    private lazy var containerBottomConstraint = NSLayoutConstraint()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectModeTrigger = PublishRelay<EventRepeatMode>()
    
    private lazy var buttons = [
        neverModeButton,
        dailyModeButton,
        weeklyModeButton,
        monthlyModeButton,
        yearlyModeButton
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
extension RepeatModeView {
    func show() {
        isHidden = false
        
        containerBottomConstraint.isActive = false
        containerBottomConstraint.constant = 0
        containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.backgroundColor = UIColor(integralRed: 36, green: 36, blue: 36, alpha: 0.4)
            self?.layoutIfNeeded()
        })
    }
    
    func hide() {
        containerBottomConstraint.isActive = false
        containerBottomConstraint.constant = 549.scale
        containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.backgroundColor = UIColor(integralRed: 36, green: 36, blue: 36, alpha: 0)
            self?.layoutIfNeeded()
        }, completion: { [weak self] result in
            self?.isHidden = true
        })
    }
    
    var didSelectMode: Signal<EventRepeatMode> {
        didSelectModeTrigger.asSignal()
    }
}

// MARK: Private
private extension RepeatModeView {
    func initialize() {
        isHidden = true
        
        backgroundColor = UIColor(integralRed: 36, green: 36, blue: 36, alpha: 0)
        
        Signal<EventRepeatMode>
            .merge(
                neverModeButton.didTap,
                dailyModeButton.didTap,
                weeklyModeButton.didTap,
                monthlyModeButton.didTap,
                yearlyModeButton.didTap
            )
            .startWith(.never)
            .emit(to: Binder(self) { base, mode in
                base.buttons.forEach { $0.marked = $0.mode == mode }
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func didTap() {
        guard let mode = buttons.first(where: { $0.marked })?.mode else {
            return
        }
        
        didSelectModeTrigger.accept(mode)
        
        hide()
    }
}

// MARK: Make constraints
private extension RepeatModeView {
    func makeConstraints() {
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 549.scale)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 549.scale),
            containerBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            buttonsContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            neverModeButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor, constant: 16.scale),
            neverModeButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor, constant: -16.scale),
            neverModeButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dailyModeButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor, constant: 16.scale),
            dailyModeButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor, constant: -16.scale),
            dailyModeButton.topAnchor.constraint(equalTo: neverModeButton.bottomAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            weeklyModeButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor, constant: 16.scale),
            weeklyModeButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor, constant: -16.scale),
            weeklyModeButton.topAnchor.constraint(equalTo: dailyModeButton.bottomAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            monthlyModeButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor, constant: 16.scale),
            monthlyModeButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor, constant: -16.scale),
            monthlyModeButton.topAnchor.constraint(equalTo: weeklyModeButton.bottomAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            yearlyModeButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor, constant: 16.scale),
            yearlyModeButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor, constant: -16.scale),
            yearlyModeButton.topAnchor.constraint(equalTo: monthlyModeButton.bottomAnchor, constant: 4.scale),
            yearlyModeButton.bottomAnchor.constraint(equalTo: buttonsContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 54.scale),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RepeatModeView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.background
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.bold(size: 20.scale))
            .lineHeight(28.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CreateEvent.Repeat.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeButtonsContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeModeButton(mode: EventRepeatMode) -> RepeatModeButton {
        let view = RepeatModeButton(mode: mode)
        view.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer.addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("CreateEvent.Button.Create".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 8.scale
        view.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
