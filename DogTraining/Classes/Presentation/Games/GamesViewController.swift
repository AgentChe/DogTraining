//
//  GamesViewController.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 22.08.2023.
//

import UIKit
import RxSwift

final class GamesViewController: UIViewController {
    lazy var mainView = GamesView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = GamesViewModel(gamesGroup: gamesGroup)
    
    private let gamesGroup: GameGroup?
    
    private init(gamesGroup: GameGroup?) {
        self.gamesGroup = gamesGroup
        
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
        
        let output = viewModel.configure(input: GamesViewModel.Input())
        
        output.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension GamesViewController {
    static func make(gamesGroup: GameGroup?) -> GamesViewController {
        let vc = GamesViewController(gamesGroup: gamesGroup)
        vc.navigationItem.title = gamesGroup?.name ?? "Games.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension GamesViewController {
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
