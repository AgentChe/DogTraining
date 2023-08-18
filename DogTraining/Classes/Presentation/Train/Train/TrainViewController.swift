//
//  TrainViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.03.2023.
//

import UIKit
import RxSwift
import RxRelay

final class TrainViewController: UIViewController {
    lazy var mainView = TrainView()
    
    private lazy var viewModel = TrainViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var externalSelectFilter = PublishRelay<TrainFilterView.Filter>()
    private var selectFilter: TrainFilterView.Filter? // На случай, если переход на фильтр был совершен на другом экране до инициализации TrainViewController
    
    private let didOpenProfile: (() -> Void)
    
    private init(didOpenProfile: @escaping () -> Void) {
        self.didOpenProfile = didOpenProfile
        
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
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        mainView.infoButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.didTapInfo()
            })
            .disposed(by: disposeBag)
        
        viewModel.sections
            .drive(Binder(mainView.tableView) { base, sections in
                base.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        addFilterActions()
        mainView.tableView.mainDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Public
extension TrainViewController {
    static func make(didOpenProfile: @escaping () -> Void) -> TrainViewController {
        let vc = TrainViewController(didOpenProfile: didOpenProfile)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
    
    func select(filter: TrainFilterView.Filter) {
        selectFilter = filter
        externalSelectFilter.accept(filter)
    }
}

// MARK: TrainTableDelegate
extension TrainViewController: TrainTableDelegate {
    func trainTableDidTappedCommands() {
        // TODO
    }
    
    func trainTableDidTapped(gamesGroup: GameGroup) {
        // TODO
//        let vc = DrillsViewController.make(drillCategory: drillCategory)
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func trainTableDidTapped(element: TrainTrainigElement.Element) {
        switch element {
        case .game(let game):
            let needPayment = game.paid ? !SessionManager().hasActiveSubscriptions() : false
            
            if needPayment {
                let vc = PaygateViewController.make()
                present(vc, animated: true)
            } else {
                let vc = GameInstructionViewController.make(game: game)
                navigationController?.pushViewController(vc, animated: true)
            }
        case .command(let command):
            let needPayment = command.paid ? !SessionManager().hasActiveSubscriptions() : false
            
            if needPayment {
                let vc = PaygateViewController.make()
                present(vc, animated: true)
            } else {
                let vc = CommandInstructionViewController.make(command: command)
                navigationController?.pushViewController(vc, animated: true)
            }
        case .training(let training):
            let needPayment = training.paid ? !SessionManager().hasActiveSubscriptions() : false
            
            if needPayment {
                let vc = PaygateViewController.make()
                present(vc, animated: true)
            } else {
                let vc = CommandsTrainingTemplateViewController.make(training: training)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: Private
private extension TrainViewController {
    func didTapInfo() {
        let vc = TrainInfoViewController.make { [weak self] in
            self?.didOpenProfile()
        }
        present(vc, animated: false)
    }
    
    func addFilterActions() {
        Observable
            .merge(
                mainView.filterView.commandsButton.rx.tap
                    .map { TrainFilterView.Filter.commands },
                mainView.filterView.gamesButton.rx.tap
                    .map { TrainFilterView.Filter.games },
                externalSelectFilter.asObservable()
            )
            .startWith(selectFilter ?? .commands)
            .bind(to: Binder(self) { base, filter in
                base.mainView.filterView.filter = filter
                base.viewModel.didSelectFilter.accept(filter)
            })
            .disposed(by: disposeBag)
    }
    
    func activity(_ activity: Bool) {
        mainView.tableView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
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
