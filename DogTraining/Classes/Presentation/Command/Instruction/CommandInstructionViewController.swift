//
//  CommandInstructionViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import UIKit
import RxSwift

final class CommandInstructionViewController: UIViewController {
    lazy var mainView = GameInstructionView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: CommandInstructionViewModel
    
    private lazy var commandTrainingAssembly = CommandTrainingAssembly()
    
    private init(command: Command) {
        viewModel = CommandInstructionViewModel(source: .command(command))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(planCommand: PlanCommand) {
        viewModel = CommandInstructionViewModel(source: .planCommand(planCommand))
        
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
extension CommandInstructionViewController {
    static func make(command: Command) -> CommandInstructionViewController {
        let vc = CommandInstructionViewController(command: command)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
    
    static func make(planCommand: PlanCommand) -> CommandInstructionViewController {
        let vc = CommandInstructionViewController(planCommand: planCommand)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: GITableDelegate
extension CommandInstructionViewController: GITableDelegate {
    func giTableDidTappedCalendar() {
        viewModel.didTapCalendar.accept(())
    }
    
    func giTableDidTappedStartTraining() {
        viewModel.didTapStartTraining.accept(Void())
    }
    
    func giTableDidTappedShowMore() {}
}

// MARK: Private
private extension CommandInstructionViewController {
    func route(_ route: CommandInstructionViewModel.Route) {
        switch route {
        case .training(let customerCommandId):
            commandTrainingAssembly.startTraining(from: self, customerCommandId: customerCommandId)
        case .calendar(let customerCommandId):
            let calendar = CalendarViewController.make(schedulerType: .command(customerCommandId: customerCommandId))
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
