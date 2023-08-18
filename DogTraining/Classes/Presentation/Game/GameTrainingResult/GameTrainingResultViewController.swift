//
//  GameTrainingResultViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit
import RxSwift

final class GameTrainingResultViewController: UIViewController {
    lazy var mainView = GameTrainingResultView(
        title: "GameTrainingResult.Title".localized,
        image: gameTraining.game.image,
        name: gameTraining.game.name,
        trainedTime: gameTraining.assignedGame.trainedTime
    )
    
    private lazy var viewModel = GameTrainingResultViewModel(gameTraining: gameTraining)
    
    private lazy var disposeBag = DisposeBag()
    
    private let gameTraining: GameTraining
    
    private init(gameTraining: GameTraining) {
        self.gameTraining = gameTraining
        
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
        
        viewModel.gameGroup
            .drive(Binder(mainView) { base, gameGroup in
                base.setup(gameGroupName: gameGroup.name)
            })
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension GameTrainingResultViewController {
    static func make(gameTraining: GameTraining) -> GameTrainingResultViewController {
        let vc = GameTrainingResultViewController(gameTraining: gameTraining)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
