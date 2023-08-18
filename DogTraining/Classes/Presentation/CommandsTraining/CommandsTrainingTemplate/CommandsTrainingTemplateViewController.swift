//
//  CommandsTrainingTemplateViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit
import RxSwift

final class CommandsTrainingTemplateViewController: UIViewController {
    lazy var mainView = CommandsTrainingTemplateView()
    
    private let viewModel: CommandsTrainingTemplateViewModel
    
    private lazy var commandsTrainingAssembly = CommandsTrainingAssembly()
    
    private lazy var disposeBag = DisposeBag()
    
    private init(training: Training) {
        viewModel = CommandsTrainingTemplateViewModel(source: .training(training))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(planTraining: PlanTraining) {
        viewModel = CommandsTrainingTemplateViewModel(source: .plan(planTraining))
        
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
            .drive(with: self) { $0.route($1) }
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension CommandsTrainingTemplateViewController {
    static func make(training: Training) -> CommandsTrainingTemplateViewController {
        let vc = CommandsTrainingTemplateViewController(training: training)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
    
    static func make(planTraining: PlanTraining) -> CommandsTrainingTemplateViewController {
        let vc = CommandsTrainingTemplateViewController(planTraining: planTraining)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: TrainingTemplateTableDelegate
extension CommandsTrainingTemplateViewController: TrainingTemplateTableDelegate {
    func tableDidTappedCalendar() {
        viewModel.didTapCalendar.accept(())
    }
    
    func tableDidTappedStartTraining() {
        viewModel.didTapStartTraining.accept(Void())
    }
    
    func tableDidTapped(command: Command) {
        let vc = CommandTemplateInstructionViewController.make(command: command)
        present(vc, animated: true)
    }
}

// MARK: Private
private extension CommandsTrainingTemplateViewController {
    func route(_ route: CommandsTrainingTemplateViewModel.Route) {
        switch route {
        case .training(let customerTrainingId):
            commandsTrainingAssembly.startTraining(from: self, customerTrainingId: customerTrainingId)
        case .calendar(let customerTrainingId):
            // TODO
            break
//            let calendar = CalendarViewController.make(schedulerType: .workout(customerWorkoutId: customerWorkoutId))
//            present(calendar, animated: true)
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
