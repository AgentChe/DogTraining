//
//  HomeViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    lazy var mainView = HomeView()
    
    private lazy var viewModel = HomeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var sessionManager = SessionManager()
    
    private let seeAllCommands: (() -> Void)
    private let seeAllGames: (() -> Void)
    private let addTrainings: (() -> Void)
    
    private init(seeAllCommands: @escaping (() -> Void), seeAllGames: @escaping (() -> Void), addTrainings: @escaping (() -> Void)) {
        self.seeAllCommands = seeAllCommands
        self.seeAllGames = seeAllGames
        self.addTrainings = addTrainings
        
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
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
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

// MARK: Make
extension HomeViewController {
    static func make(seeAllCommands: @escaping (() -> Void), seeAllGames: @escaping (() -> Void), addTrainings: @escaping (() -> Void)) -> HomeViewController {
        let vc = HomeViewController(seeAllCommands: seeAllCommands, seeAllGames: seeAllGames, addTrainings: addTrainings)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: HomeTableViewDelegate
extension HomeViewController: HomeTableViewDelegate {
    func homeTableDidTap(game: Game) {
        let needPayment = game.paid ? !sessionManager.hasActiveSubscriptions() : false
        
        if needPayment {
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        } else {
            // TODO: open screen
        }
    }
    
    func homeTableDidTap(training: Training) {
        // TODO: open screen
    }
    
    func homeTableDidTap(planDay: Date) {
        viewModel.didTapPlanDay.accept(planDay)
    }
    
    func homeTableDidTap(planGame: PlanGame) {
        // TODO: open screen
    }
    
    func homeTableDidTap(planTraining: PlanTraining) {
        // TODO: open screen
    }
    
    func homeTableDidTap(planCommand: PlanCommand) {
        // TODO: open screen
    }
    
    func homeTableDidTapAddTraining() {
        addTrainings()
    }
    
    func homeTableDidTap(commandGroup: CommandGroup) {
        // TODO: open screen
    }
    
    func homeTableDidTapTryCommands() {
        seeAllCommands()
    }
    
    func homeTableDidTapGames() {
        seeAllGames()
    }
    
    func homeTableDidTap(command: Command) {
        // TODO: open screen
    }
}

// MARK: Private
private extension HomeViewController {
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
