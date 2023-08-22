//
//  ArticleViewController.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 22.08.2023.
//

import UIKit
import RxSwift

final class ArticleViewController: UIViewController {
    lazy var mainView = ArticleView()
    
    private lazy var viewModel = ArticleViewModel(articleId: articleId)
    
    private lazy var disposeBag = DisposeBag()
    
    private let articleId: Int
    
    private init(articleId: Int) {
        self.articleId = articleId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
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
        
        let output = viewModel.configure(input: ArticleViewModel.Input())
        
        output.articleDetails
            .drive(Binder(mainView) { base, articleDetails in
                base.setup(articleDetails: articleDetails)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                base.scrollView.isHidden = activity
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ArticleViewController {
    static func make(articleId: Int) -> ArticleViewController {
        let vc = ArticleViewController(articleId: articleId)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ArticleViewController {
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
