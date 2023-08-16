//
//  CommandTrainingViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit
import RxSwift

final class CommandTrainingViewController: UIViewController {
    lazy var mainView = CommandTrainingView()
    
    private let viewModel: CommandTrainingViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var lifeCyrcle = GameTrainingLifeCyrcle()
    
    private let didFinish: ((CommandTraining) -> Void)
    
    private init(customerCommandId: Int, didFinish: @escaping ((CommandTraining) -> Void)) {
        viewModel = CommandTrainingViewModel(customerCommandId: customerCommandId)
        self.didFinish = didFinish
        
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
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        Observable
            .merge(
                mainView.closeButton.rx.tap.asObservable(),
                mainView.menuView.finishButton.rx.tap.asObservable()
            )
            .bind(to: Binder(self) { base, void in
                base.cancelTraining()
            })
            .disposed(by: disposeBag)
        
        viewModel.command
            .drive(Binder(mainView) { base, command in
                base.setup(command: command)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        viewModel.startTraining
            .emit(to: Binder(lifeCyrcle) { base, void in
                base.startTraining()
            })
            .disposed(by: disposeBag)
        
        mainView.menuView.playPauseButton.rx.tap
            .bind(to: Binder(self) { base, void in
                switch base.mainView.menuView.playPauseButton.stateCode {
                case .pause:
                    base.lifeCyrcle.continueTraining()
                case .play:
                    base.lifeCyrcle.pauseTraining()
                }
            })
            .disposed(by: disposeBag)
        
        mainView.menuView.instructionButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.openInstruction()
            })
            .disposed(by: disposeBag)
        
        mainView.instructionView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.hideInstruction()
            })
            .disposed(by: disposeBag)
        
        mainView.menuView.refreshButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.lifeCyrcle.refreshTraining()
            })
            .disposed(by: disposeBag)
        
        gameTrainingPrepare()
        lifeCyrcle.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension CommandTrainingViewController {
    static func make(customerCommandId: Int, didFinish: @escaping ((CommandTraining) -> Void)) -> CommandTrainingViewController {
        let vc = CommandTrainingViewController(customerCommandId: customerCommandId, didFinish: didFinish)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: GameTrainingLifeCyrcleDelegate
extension CommandTrainingViewController: GameTrainingLifeCyrcleDelegate {
    func gameTrainingPrepare() {
        mainView.closeButton.isHidden = true
        mainView.pausedLabel.isHidden = true
        mainView.setup(prepared: "")
        mainView.setup(prepareTick: "")
        mainView.setup(trainingTick: "")
        mainView.menu(hidden: true, animated: false)
        mainView.instruction(hidden: true, animated: false)
    }
    
    func gameTrainingReadyIn(seconds: Int) {
        let string = String(format: "0:0%i", seconds)
        mainView.setup(prepareTick: string)
    }
    
    func gameTrainingPrepared() {
        mainView.setup(prepared: "GameTraining.Go".localized)
    }
    
    func gameTrainingDidStart() {
        mainView.closeButton.isHidden = false
        mainView.pausedLabel.isHidden = true
        mainView.menu(hidden: false)
        mainView.setup(prepared: "")
        mainView.setup(prepareTick: "")
        mainView.menuView.playPauseButton.stateCode = .play
    }
    
    func gameTrainingTick(seconds: Int) {
        var mins = 0
        var secs = seconds
        if seconds >= 60 {
            mins = Int(seconds / 60)
            secs = seconds - (mins * 60)
        }
        let string = String(format: "%02d:%02d", mins, secs)
        
        mainView.setup(trainingTick: string)
        
        mainView.menuView.playPauseButton.stateCode = .play
    }
    
    func gameTrainigPaused() {
        mainView.pausedLabel.isHidden = false
        mainView.menuView.playPauseButton.stateCode = .pause
    }
    
    func gameTrainingStopped(totalSeconds: Int) {
        mainView.instruction(hidden: true, animated: false)
        mainView.menu(hidden: true, animated: false)
        
        mainView.pausedLabel.isHidden = false
        mainView.menuView.playPauseButton.stateCode = .pause
        
        viewModel.didFinishTraining.accept(totalSeconds)
    }
}

// MARK: Private
private extension CommandTrainingViewController {
    func route(_ route: CommandTrainingViewModel.Route) {
        switch route {
        case .finished(let commandTraining):
            dismiss(animated: true) { [weak self] in
                self?.didFinish(commandTraining)
            }
        }
    }
    
    func cancelTraining() {
        lifeCyrcle.pauseTraining()
        
        mainView.instruction(hidden: true, animated: false)
        mainView.menu(hidden: true, animated: false)
        
        let vc = GameTrainingQuitViewController.make(element: .command) { [weak self] finish in
            if finish {
                self?.lifeCyrcle.stopTraining()
            } else {
                self?.lifeCyrcle.continueTraining()
            }
        }
        present(vc, animated: false)
    }
    
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func openInstruction() {
        mainView.menu(hidden: true) { [weak self] in
            self?.mainView.instruction(hidden: false) {
                self?.lifeCyrcle.pauseTraining()
            }
        }
    }
    
    func hideInstruction() {
        mainView.instruction(hidden: true) { [weak self] in
            self?.mainView.menu(hidden: false) {
                self?.lifeCyrcle.continueTraining()
            }
        }
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
