//
//  ClearedTextField.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 11.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class ClearedTextField: UIView {
    enum State {
        case none, focus
    }
    
    lazy var iconView = makeIconView()
    lazy var textField = makeTextField()
    lazy var clearButton = makeClearButton()
    
    private lazy var state = BehaviorRelay(value: State.none)
    private lazy var text = BehaviorRelay(value: "")
    
    private let placeholder: String
    
    init(placeholder: String) {
        self.placeholder = placeholder
        
        super.init(frame: .zero)
        
        makeConstraints()
        textEditing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ClearedTextField {
    func setup(text: String) {
        textField.text = text
        textEditing()
    }
    
    var changedState: Signal<State> {
        state.asSignal(onErrorSignalWith: .never())
    }
    
    var changedText: Signal<String> {
        text
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: UITextFieldDelegate
extension ClearedTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField === self.textField else {
            return
        }
        
        state.accept(.focus)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField === self.textField else {
            return
        }
        
        state.accept(.none)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension ClearedTextField {
    @objc
    func clearTapped() {
        textField.text = ""
        textEditing()
    }
    
    @objc
    func textEditing() {
        clearButton.isHidden = (textField.text ?? "").isEmpty
        
        text.accept(textField.text ?? "")
    }
}

// MARK: Make constraints
private extension ClearedTextField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44.scale),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 24.scale),
            clearButton.heightAnchor.constraint(equalToConstant: 24.scale),
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            clearButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ClearedTextField {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Breeds.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(25.6.scale)
        
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.4))
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(25.6.scale)
        
        let view = PaddingTextField()
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.textPadding = UIEdgeInsets.zero
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = placeholder.attributed(with: placeholderAttrs)
        view.addTarget(self, action: #selector(textEditing), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeClearButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Onboarding.Breeds.Clear"), for: .normal)
        view.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
