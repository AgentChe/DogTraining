//
//  EventTimeView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 28.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class EventTimeView: UIView {
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var datePicker = makeDatePicker()
    lazy var saveButton = makeSaveButton()
    
    private lazy var containerBottomConstraint = NSLayoutConstraint()
    
    private lazy var didSelectDateTrigger = PublishRelay<Date>()
    
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
extension EventTimeView {
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
    
    var didSelectDate: Signal<Date> {
        didSelectDateTrigger.asSignal()
    }
}

// MARK: Private
private extension EventTimeView {
    func initialize() {
        isHidden = true
        
        backgroundColor = UIColor(integralRed: 36, green: 36, blue: 36, alpha: 0)
    }
    
    @objc
    func didTap() {
        didSelectDateTrigger.accept(datePicker.date)
        
        hide()
    }
}

// MARK: Make constraints
private extension EventTimeView {
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
            datePicker.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48.scale),
            datePicker.heightAnchor.constraint(equalToConstant: 248.scale)
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
private extension EventTimeView {
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
        view.attributedText = "CreateEvent.EventTime.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeDatePicker() -> UIDatePicker {
        let view = UIDatePicker()
        view.minimumDate = Date()
        view.preferredDatePickerStyle = .wheels
        view.datePickerMode = .dateAndTime
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("CreateEvent.EventTime.Button".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 8.scale
        view.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
