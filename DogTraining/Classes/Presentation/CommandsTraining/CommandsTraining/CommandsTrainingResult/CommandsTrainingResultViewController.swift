//
//  CommandsTrainingResultViewController.swift
//  Soccer
//
//  Created by Виталий Загороднов on 13.04.2023.
//

import UIKit
import RxSwift

class CommandsTrainingResultViewController: UIViewController {
    lazy var mainView = CommandsTrainingResultView(details: trainingDetails)
    
    private lazy var viewModel = CommandsTrainingResultViewModel(trainingDetails: trainingDetails)
    
    private lazy var disposeBag = DisposeBag()
    
    private let trainingDetails: TrainingDetails
    
    private init(trainingDetails: TrainingDetails) {
        self.trainingDetails = trainingDetails
        
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
                mainView.closeButton.rx.tap.asObservable(),
                mainView.continueButton.rx.tap.asObservable()
            )
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.skillLevel
            .drive(Binder(mainView) { base, skillLevel in
                base.setup(skillLevel: skillLevel)
            })
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension CommandsTrainingResultViewController {
    static func make(trainingDetails: TrainingDetails) -> CommandsTrainingResultViewController {
        let vc = CommandsTrainingResultViewController(trainingDetails: trainingDetails)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
