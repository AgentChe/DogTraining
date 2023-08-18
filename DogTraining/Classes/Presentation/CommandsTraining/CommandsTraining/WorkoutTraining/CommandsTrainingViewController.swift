//
//  CommandsTrainingViewController.swift
//  Soccer
//
//  Created by Виталий Загороднов on 23.03.2023.
//

import UIKit
import RxSwift
import RxCocoa

class CommandsTrainingViewController: UIViewController {
    lazy var mainView = CommandsTrainingView()
    
    private let viewModel: CommandsTrainingViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var lifeCyrcle = CommandsTrainingLifeCyrcle()
    
    private lazy var didStartStepRelay = PublishRelay<Void>()
    
    private let didFinish: ((TrainingDetails) -> Void)

    private init(customerTrainingId: Int, didFinish: @escaping ((TrainingDetails) -> Void)) {
        self.viewModel = CommandsTrainingViewModel(customerTrainingId: customerTrainingId)
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
            .withLatestFrom(viewModel.currentAndNextCommand)
            .bind(to: Binder(self) { base, tuple in
                base.cancelTraining(commandId: tuple.current.id)
            })
            .disposed(by: disposeBag)
        
        viewModel.didFinishCommand
            .asObservable()
            .mapToVoid()
            .asSignal(onErrorSignalWith: .never())
            .emit(to: viewModel.didTapNext)
            .disposed(by: disposeBag)
        
        mainView.menuView.previosButton.rx.tap
            .asSignal()
            .emit(to: viewModel.didTapPrevios)
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.commands
            .drive(with: mainView) {
                $0.collectionView.setup(elements: $1)
                $0.progressView.segmentCount = $1.count
            }
            .disposed(by: disposeBag)
        
        viewModel.currentIndex
            .drive(with: mainView) { base, index in
                base.collectionView.scrollToItem(at: .init(row: index, section: 0), at: .centeredHorizontally, animated: true)
                base.progressView.currentIndex = index + 1
            }
            .disposed(by: disposeBag)
        
        viewModel.route
            .emit(to: Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        mainView.menuView.nextButton.rx.tap
            .withLatestFrom(viewModel.currentAndNextCommand.asObservable())
            .bind(with: self) { base, tuple in
                base.lifeCyrcle.stopTraining(commandId: tuple.current.id)
            }
            .disposed(by: disposeBag)
        
        didStartStepRelay
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { base, step in
                base.viewModel.currentAndNextCommand
                    .asObservable()
            }
            .bind(to: Binder(self) { base, value in
                base.mainView.setup(current: value.current, next: value.next)
                base.lifeCyrcle.startTraining()
            })
            .disposed(by: disposeBag)
        
        viewModel.currentIndex
            .withLatestFrom(viewModel.commands) { $0 == $1.count - 1 }
            .drive(with: mainView.menuView) {
                $0.finishButton.isHidden = !$1
                $0.instructionButton.isHidden = $1
                $0.nextContainerView.isHidden = $1
            }
            .disposed(by: disposeBag)
        
        viewModel.menuState
            .drive(with: mainView.menuView) { view, state in
                switch state {
                case .last:
                    view.nextButton.isHidden = true
                    view.previosButton.isHidden = false
                case .middle:
                    view.nextButton.isHidden = false
                    view.previosButton.isHidden = false
                case .first:
                    view.previosButton.isHidden = true
                    view.nextButton.isHidden = false
                }
            }
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
        
        rx.methodInvoked(#selector(viewDidLayoutSubviews))
            .take(1)
            .subscribe(Binder(lifeCyrcle) { base, value in
                base.start()
            })
            .disposed(by: disposeBag)
        
        lifeCyrcle.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

extension CommandsTrainingViewController {
    static func make(customerTrainingId: Int, didFinish: @escaping ((TrainingDetails) -> Void)) -> CommandsTrainingViewController {
        let vc = CommandsTrainingViewController(customerTrainingId: customerTrainingId, didFinish: didFinish)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: CommandsTrainingLifeCyrcleDelegate
extension CommandsTrainingViewController: CommandsTrainingLifeCyrcleDelegate {
    func commandsTrainingPrepare() {
        mainView.closeButton.isHidden = true
        mainView.pausedLabel.isHidden = true
        mainView.trainingTickLabel.isHidden = true
        mainView.setup(prepared: "")
        mainView.setup(prepareTick: "")
        mainView.setup(trainingTick: "")
        mainView.menu(hidden: true, animated: false)
        mainView.instruction(hidden: true, animated: false)
    }
    
    func commandsTrainingReadyIn(seconds: Int) {
        let string = String(format: "0:0%i", seconds)
        mainView.setup(prepareTick: string)
    }
    
    func commandsTrainingPrepared() {
        mainView.setup(prepared: "CommandsTraining.Go".localized)
    }
    
    func commandsTrainingDidStart() {
        mainView.closeButton.isHidden = false
        mainView.pausedLabel.isHidden = true
        mainView.trainingTickLabel.isHidden = false
        mainView.menu(hidden: false)
        mainView.setup(prepared: "")
        mainView.setup(prepareTick: "")
        mainView.menuView.playPauseButton.stateCode = .play
    }
    
    func commandsTrainingStartStep() {
        didStartStepRelay.accept(())
    }
    
    func commandsTrainingTick(seconds: Int) {
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
    
    func commandsTrainigPaused() {
        mainView.pausedLabel.isHidden = false
        mainView.menuView.playPauseButton.stateCode = .pause
    }
    
    func commandsTrainingStopped(totalSeconds: Int, commandId: Int) {
        viewModel.didFinishCommand.accept((totalSeconds, commandId))
    }
    
    func commandsTrainingFinish(totalSeconds: Int, commandId: Int) {
        mainView.instruction(hidden: true, animated: false)
        mainView.menu(hidden: true, animated: false)
        
        mainView.pausedLabel.isHidden = false
        mainView.menuView.playPauseButton.stateCode = .pause
        
        viewModel.didFinishTraining.accept((totalSeconds, commandId))
    }
}

// MARK: Private
private extension CommandsTrainingViewController {
    func route(_ route: CommandsTrainingViewModel.Route) {
        switch route {
        case .finished(let trainingDetails):
            dismiss(animated: true) { [weak self] in
                self?.didFinish(trainingDetails)
            }
        }
    }
    
    func cancelTraining(commandId: Int) {
        lifeCyrcle.pauseTraining()
        
        mainView.instruction(hidden: true, animated: false)
        mainView.menu(hidden: true, animated: false)
        
        let vc = CommandsTrainingQuitViewController.make { [weak self] finish in
            if finish {
                self?.lifeCyrcle.finishTraining(commandId: commandId)
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
