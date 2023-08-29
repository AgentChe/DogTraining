//
//  ChooseEventTypeViewController.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 28.08.2023.
//

import UIKit
import RxSwift

final class ChooseEventTypeViewController: UIViewController {
    lazy var mainView = ChooseEventTypeView()
    
    private lazy var viewModel = ChooseEventTypeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let didClose: ((ChooseEventTypeViewController) -> Void)
    private let didSelect: ((EventType, ChooseEventTypeViewController) -> Void)
    
    private init(didClose: @escaping ((ChooseEventTypeViewController) -> Void), didSelect: @escaping (EventType, ChooseEventTypeViewController) -> Void) {
        self.didClose = didClose
        self.didSelect = didSelect
        
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
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.didClose(base)
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: ChooseEventTypeViewModel.Input(
            didSelectElement: mainView.tableView.didSelectElement
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ChooseEventTypeViewController {
    static func make(didClose: @escaping ((ChooseEventTypeViewController) -> Void), didSelect: @escaping (EventType, ChooseEventTypeViewController) -> Void) -> ChooseEventTypeViewController {
        ChooseEventTypeViewController(didClose: didClose, didSelect: didSelect)
    }
}

// MARK: Private
private extension ChooseEventTypeViewController {
    func route(_ route: ChooseEventTypeViewModel.Route) {
        switch route {
        case .create(let type):
            didSelect(type, self)
        }
    }
}
