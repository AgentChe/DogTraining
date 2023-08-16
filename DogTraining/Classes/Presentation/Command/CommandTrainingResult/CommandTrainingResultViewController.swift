//
//  CommandTrainingResultViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit
import RxSwift

final class CommandTrainingResultViewController: UIViewController {
    lazy var mainView = GameTrainingResultView(
        title: "CommandTrainingResult.Title".localized,
        image: commandTraining.command.image,
        name: commandTraining.command.name,
        trainedTime: commandTraining.assignedCommand.trainedTime
    )
    
    private lazy var viewModel = CommandTrainingResultViewModel(commandTraining: commandTraining)
    
    private lazy var disposeBag = DisposeBag()
    
    private let commandTraining: CommandTraining
    
    private init(commandTraining: CommandTraining) {
        self.commandTraining = commandTraining
        
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
        
        viewModel.commandGroup
            .drive(Binder(mainView) { base, commandGroup in
                base.setup(gameGroupName: commandGroup.name)
            })
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension CommandTrainingResultViewController {
    static func make(commandTraining: CommandTraining) -> CommandTrainingResultViewController {
        let vc = CommandTrainingResultViewController(commandTraining: commandTraining)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
