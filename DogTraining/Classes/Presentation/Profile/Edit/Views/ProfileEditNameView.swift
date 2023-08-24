//
//  ProfileEditNameView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditNameView: UIView {
    var didSave: ((String) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var textField = makeTextField()
    lazy var continueButton = makeContinueButton()
    
    private lazy var disposeBag = DisposeBag()
    
    init(dogName: String?) {
        super.init(frame: .zero)
        
        makeConstraints()
        initialize(dogName: dogName)
        checkEnable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ProfileEditNameView {
    func initialize(dogName: String?) {
        backgroundColor = Appearance.background
        
        let hideKeyboardGesture = UITapGestureRecognizer()
        isUserInteractionEnabled = true
        addGestureRecognizer(hideKeyboardGesture)
        hideKeyboardGesture.rx.event
            .bind(to: Binder(textField.textField) { base, event in
                base.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        textField.changedText
            .asDriver(onErrorDriveWith: .never())
            .drive(Binder(self) { base, text in
                base.checkEnable()
            })
            .disposed(by: disposeBag)
        
        textField.textField.text = dogName
        textField.textField.sendActions(for: .editingChanged)
    }
    
    func checkEnable() {
       let marked = !(textField.textField.text ?? "").isEmpty
        continueButton.isEnabled = marked
        continueButton.alpha = marked ? 1 : 0.4
    }
    
    @objc
    func didTapContinue() {
        textField.textField.resignFirstResponder()
        
        didSave?(textField.textField.text ?? "")
    }
}

// MARK: Make constraints
private extension ProfileEditNameView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textField.heightAnchor.constraint(equalToConstant: 52.scale),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -62.scale : -32.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileEditNameView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.DogName.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> ClearedTextField {
        let view = ClearedTextField(placeholder: "Onboarding.DogName.Placeholder".localized)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 8.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
