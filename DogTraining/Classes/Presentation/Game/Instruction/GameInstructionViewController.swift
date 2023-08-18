//
//  GameInstructionViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import UIKit
import RxSwift

final class GameInstructionViewController: UIViewController {
    lazy var mainView = GameInstructionView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: GameInstructionViewModel
    
    private lazy var gameTrainingAssembly = GameTrainingAssembly()
    
    private init(game: Game) {
        viewModel = GameInstructionViewModel(source: .game(game))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(planGame: PlanGame) {
        viewModel = GameInstructionViewModel(source: .planGame(planGame))
        
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
        
        viewModel.assignActivity
            .drive(Binder(self) { base, activity in
                base.assignActivity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        viewModel.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension GameInstructionViewController {
    static func make(game: Game) -> GameInstructionViewController {
        let vc = GameInstructionViewController(game: game)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
    
    static func make(planGame: PlanGame) -> GameInstructionViewController {
        let vc = GameInstructionViewController(planGame: planGame)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: DTITableDelegate
extension GameInstructionViewController: GITableDelegate {
    func giTableDidTappedCalendar() {
        viewModel.didTapCalendar.accept(())
    }
    
    func giTableDidTappedStartTraining() {
        viewModel.didTapStartTraining.accept(Void())
    }
    
    func giTableDidTappedShowMore() {
        viewModel.didTapShowMore.accept(Void())
    }
}

// MARK: Private
private extension GameInstructionViewController {
    func route(_ route: GameInstructionViewModel.Route) {
        switch route {
        case .training(let customerGameId):
            gameTrainingAssembly.startTraining(from: self, customerGameId: customerGameId)
        case .calendar(let customerGameId):
            let calendar = CalendarViewController.make(schedulerType: .game(customerGameId: customerGameId))
            present(calendar, animated: true)
        }
    }
    
    func activity(_ activity: Bool) {
        mainView.tableView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func assignActivity(_ activity: Bool) {
        activity ? mainView.screenPreloader.startAnimating() : mainView.screenPreloader.stopAnimating()
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
