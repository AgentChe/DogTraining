//
//  CommandsViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit
import RxSwift

final class CommandsViewController: UIViewController {
    lazy var mainView = CommandsView()
    
    private lazy var viewModel = CommandsViewModel(commandGroup: commandGroup)
    
    private lazy var disposeBag = DisposeBag()
    
    private let commandGroup: CommandGroup
    
    private init(commandGroup: CommandGroup) {
        self.commandGroup = commandGroup
        
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
}

// MARK: Make
extension CommandsViewController {
    static func make(commandGroup: CommandGroup) -> CommandsViewController {
        let vc = CommandsViewController(commandGroup: commandGroup)
        vc.navigationItem.title = commandGroup.name
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: CommandsTableDelegate
extension CommandsViewController: CommandsTableDelegate {
    func commandsTableDidTap(element: CommandsTableElement) {
        if element.locked {
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        } else {
            let vc = CommandInstructionViewController.make(command: element.command)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: Private
private extension CommandsViewController {
    func activity(_ activity: Bool) {
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
