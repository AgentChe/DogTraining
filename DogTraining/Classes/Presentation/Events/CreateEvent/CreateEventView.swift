//
//  CreateEventView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 28.08.2023.
//

import UIKit

final class CreateEventView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var scrollView = makeScrollView()
    lazy var typeImageContainer = makeTypeImageContainer()
    lazy var typeImageView = makeTypeImageView()
    lazy var typeLabel = makeTypeLabel()
    lazy var separator = makeSeparator()
    lazy var noteField = makeNoteField()
    lazy var selectDateView = makeSelectDateView()
    lazy var selectRepeatView = makeSelectRepeatView()
    lazy var saveButton = makeSaveButton()
    lazy var removeButton = makeRemoveButton()
    lazy var eventTimeView = makeEventTimeView()
    lazy var repeatModeView = makeRepeatModeView()
    lazy var confirmRemoveView = makeConfirmRemoveView()
    
    private let mode: CreateEventViewController.Mode
    
    init(mode: CreateEventViewController.Mode) {
        self.mode = mode
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextFieldDelegate
extension CreateEventView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension CreateEventView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    func data(for type: EventType) -> (String, UIImage?) {
        let key: String
        
        switch type {
        case .vaccination:
            key = "EventType.Vaccination"
        case .antiParasitic:
            key = "EventType.AntiParasitic"
        case .medicine:
            key = "EventType.Medicine"
        case .symptoms:
            key = "EventType.Symptoms"
        case .vetVisit:
            key = "EventType.VetVisit"
        case .care:
            key = "EventType.Care"
        case .other:
            key = "EventType.Other"
        }
        
        return (
            key.localized,
            UIImage(named: key)
        )
    }
}

// MARK: Make constraints
private extension CreateEventView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            typeImageContainer.widthAnchor.constraint(equalToConstant: 80.scale),
            typeImageContainer.heightAnchor.constraint(equalToConstant: 80.scale),
            typeImageContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            typeImageContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            typeImageView.widthAnchor.constraint(equalToConstant: 40.scale),
            typeImageView.heightAnchor.constraint(equalToConstant: 40.scale),
            typeImageView.centerXAnchor.constraint(equalTo: typeImageContainer.centerXAnchor),
            typeImageView.centerYAnchor.constraint(equalTo: typeImageContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            typeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            typeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            typeLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            typeLabel.topAnchor.constraint(equalTo: typeImageContainer.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            noteField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            noteField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            noteField.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            selectDateView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            selectDateView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            selectDateView.topAnchor.constraint(equalTo: noteField.bottomAnchor, constant: 16.scale),
            selectDateView.heightAnchor.constraint(equalToConstant: 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            selectRepeatView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            selectRepeatView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            selectRepeatView.topAnchor.constraint(equalTo: selectDateView.bottomAnchor, constant: 16.scale),
            selectRepeatView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            selectRepeatView.heightAnchor.constraint(equalToConstant: 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
        if mode.isCreate {
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale).isActive = true
        } else {
            saveButton.bottomAnchor.constraint(equalTo: removeButton.topAnchor, constant: -12.scale).isActive = true
        }
        
        NSLayoutConstraint.activate([
            removeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            removeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            removeButton.heightAnchor.constraint(equalToConstant: 54.scale),
            removeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            eventTimeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            eventTimeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            eventTimeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            eventTimeView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            repeatModeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            repeatModeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            repeatModeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            repeatModeView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            confirmRemoveView.leadingAnchor.constraint(equalTo: leadingAnchor),
            confirmRemoveView.trailingAnchor.constraint(equalTo: trailingAnchor),
            confirmRemoveView.bottomAnchor.constraint(equalTo: bottomAnchor),
            confirmRemoveView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateEventView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Paygate.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.2.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CreateEvent.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.contentInset = UIEdgeInsets.zero
        view.setContentOffset(CGPoint.zero, animated: false)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTypeImageContainer() -> CircleView {
        let view = CircleView()
        view.backgroundColor = Appearance.white
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeTypeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = data(for: mode.eventType).1
        view.translatesAutoresizingMaskIntoConstraints = false
        typeImageContainer.addSubview(view)
        return view
    }
    
    func makeTypeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.4))
            .font(Fonts.Inter.regular(size: 20.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = data(for: mode.eventType).0.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 180, green: 169, blue: 158, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeNoteField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(25.6.scale)
        
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.4))
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(25.6.scale)
        
        let view = PaddingTextField()
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 223, green: 225, blue: 217).cgColor
        view.delegate = self
        view.backgroundColor = Appearance.white
        view.textPadding = UIEdgeInsets(top: 13.scale, left: 8.scale, bottom: 13.scale, right: 8.scale)
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "CreateEvent.AddNote".localized.attributed(with: placeholderAttrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeSelectDateView() -> SelectView {
        let view = SelectView(title: "CreateEvent.Date".localized)
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 223, green: 225, blue: 217).cgColor
        view.backgroundColor = Appearance.white
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeSelectRepeatView() -> SelectView {
        let view = SelectView(title: "CreateEvent.Repeat".localized)
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 223, green: 225, blue: 217).cgColor
        view.backgroundColor = Appearance.white
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
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
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRemoveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.isHidden = mode.isCreate
        view.setAttributedTitle("CreateEvent.Button.Remove".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor(integralRed: 233, green: 225, blue: 217)
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEventTimeView() -> EventTimeView {
        let view = EventTimeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRepeatModeView() -> RepeatModeView {
        let view = RepeatModeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeConfirmRemoveView() -> RemoveEventConfirmView {
        let view = RemoveEventConfirmView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
