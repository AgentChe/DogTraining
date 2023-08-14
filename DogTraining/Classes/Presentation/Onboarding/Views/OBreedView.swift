//
//  OBreedView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 11.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class OBreedView: OSlideView {
    lazy var skipButton = makeSkipButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var textField = makeTextField()
    lazy var tableView = makeTableView()
    lazy var continueButton = makeContinueButton()
    
    private var selectedBreed: Breed?
    
    private lazy var contentManager = ContentManager()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        checkEnable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OBreedView {
    func initialize() {
        backgroundColor = Appearance.background
        
        contentManager
            .obtainBreeds(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .flatMapLatest { [weak self] breeds -> Driver<[Breed]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.textField.changedText
                    .debounce(RxTimeInterval.milliseconds(500))
                    .map { filter -> [Breed] in
                        guard !filter.isEmpty else {
                            return breeds
                        }
                        
                        return breeds.filter { $0.name.uppercased().contains(filter.uppercased()) }
                    }
                    .startWith(breeds)
                    .asDriver(onErrorJustReturn: [])
            }
            .drive(Binder(tableView) { base, breeds in
                base.setup(elements: breeds)
            })
            .disposed(by: disposeBag)
        
        textField.changedState
            .asDriver(onErrorDriveWith: .never())
            .drive(Binder(tableView) { base, state in
                base.isHidden = state != .focus
            })
            .disposed(by: disposeBag)
        
        rx.keyboardHeight
            .asDriver(onErrorJustReturn: 0)
            .drive(Binder(tableView) { base, keyboardHeight in
                base.contentInset.bottom = keyboardHeight > 0 ? keyboardHeight : 16.scale
            })
            .disposed(by: disposeBag)
        
        tableView.didSelect = { [weak self] breed in
            self?.selectedBreed = breed
            self?.checkEnable()
            self?.textField.setup(text: breed.name)
            self?.textField.textField.resignFirstResponder()
        }
    }
    
    func checkEnable() {
        continueButton.isHidden = selectedBreed == nil
    }
}

// MARK: Make constraints
private extension OBreedView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            skipButton.topAnchor.constraint(equalTo: topAnchor, constant: 70.scale)
        ])
        
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
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OBreedView {
    func makeSkipButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.regular(size: 16.scale))
        
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.setAttributedTitle("Onboarding.Breeds.Skip".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Breeds.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> ClearedTextField {
        let view = ClearedTextField(placeholder: "Onboarding.Breeds.Placeholder".localized)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> OBreedsTableView {
        let view = OBreedsTableView()
        view.backgroundColor = Appearance.white
        view.showsVerticalScrollIndicator = false
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = UIColor(integralRed: 233, green: 225, blue: 217).cgColor
        view.separatorInset = UIEdgeInsets(top: 0, left: 12.scale, bottom: 0, right: 0)
        view.separatorColor = UIColor(integralRed: 242, green: 237, blue: 232)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16.scale, right: 0)
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
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
