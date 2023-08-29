//
//  RemoveEventConfirmView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 29.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class RemoveEventConfirmView: UIView {
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var removeButton = makeRemoveButton()
    lazy var cancelButton = makeCancelButton()
    
    private lazy var containerBottomConstraint = NSLayoutConstraint()
    
    private lazy var disposeBag = DisposeBag()
    
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
extension RemoveEventConfirmView {
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
        containerBottomConstraint.constant = 304.scale
        containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.backgroundColor = UIColor(integralRed: 36, green: 36, blue: 36, alpha: 0)
            self?.layoutIfNeeded()
        }, completion: { [weak self] result in
            self?.isHidden = true
        })
    }
    
    var didTapRemove: Signal<Void> {
        removeButton.rx.tap
            .asSignal()
            .do(onNext: { [weak self] in
                self?.hide()
            })
    }
}

// MARK: Private
private extension RemoveEventConfirmView {
    func initialize() {
        isHidden = true
        
        backgroundColor = UIColor(integralRed: 36, green: 36, blue: 36, alpha: 0)
        
        cancelButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.hide()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension RemoveEventConfirmView {
    func makeConstraints() {
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 304.scale)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 304.scale),
            containerBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            removeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            removeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            removeButton.heightAnchor.constraint(equalToConstant: 54.scale),
            removeButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            cancelButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            cancelButton.heightAnchor.constraint(equalToConstant: 54.scale),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -50.scale : -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RemoveEventConfirmView {
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
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CreateEvent.Remove.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(25.6.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CreateEvent.Remove.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeRemoveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("CreateEvent.Remove.Remove".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCancelButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("CreateEvent.Remove.Cancel".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor(integralRed: 233, green: 225, blue: 217)
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
