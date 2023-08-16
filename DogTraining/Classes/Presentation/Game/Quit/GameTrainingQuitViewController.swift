//
//  GameTrainingQuitViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit
import RxSwift

final class GameTrainingQuitViewController: UIViewController {
    enum Element {
        case game, command
        
        var subTitle: String {
            switch self {
            case .game:
                return "GameTrainingQuit.SubTitle".localized
            case .command:
                return "CommandTrainingQuit.SubTitle".localized
            }
        }
        
        var continueButtonTitle: String {
            switch self {
            case .game:
                return "GameTrainingQuit.Continue".localized
            case .command:
                return "CommandTrainingQuit.Continue".localized
            }
        }
        
        var finishButtonTitle: String {
            switch self {
            case .game:
                return "GameTrainingQuit.Finish".localized
            case .command:
                return "CommandTrainingQuit.Finish".localized
            }
        }
    }
    
    lazy var mainView = GameTrainingQuitView(
        subTitle: element.subTitle,
        continueButton: element.continueButtonTitle,
        finishButton: element.finishButtonTitle
    )

    private lazy var disposeBag = DisposeBag()

    private let element: Element
    private let completion: (Bool) -> Void

    private init(element: Element, completion: @escaping (Bool) -> Void) {
        self.element = element
        self.completion = completion

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Observable
            .merge(
                mainView.continueButton.rx.tap.map { false },
                mainView.finishButton.rx.tap.map { true }
            )
            .bind(to: Binder(self) { base, finish in
                base.dismiss(finish: finish)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateShow()
    }
}

// MARK: Make
extension GameTrainingQuitViewController {
    static func make(element: Element, completion: @escaping (Bool) -> Void) -> GameTrainingQuitViewController {
        let vc = GameTrainingQuitViewController(element: element, completion: completion)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension GameTrainingQuitViewController {
    func animateShow() {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 0
        mainView.containerBottomConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0.6
            self?.mainView.layoutIfNeeded()
        })
    }

    func dismiss(finish: Bool) {
        animateDismiss { [weak self] in
            self?.dismiss(animated: false) {
                self?.completion(finish)
            }
        }
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 304.scale
        mainView.containerBottomConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0
            self?.mainView.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}
