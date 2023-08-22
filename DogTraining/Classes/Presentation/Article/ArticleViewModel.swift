//
//  ArticleViewModel.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 22.08.2023.
//

import RxSwift
import RxCocoa

final class ArticleViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var articlesManager = ArticlesManager()
    
    private let articleId: Driver<Int>
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(articleId: Int) {
        self.articleId = BehaviorRelay(value: articleId).asDriver()
    }
}

// MARK: Public
extension ArticleViewModel {
    struct Input {}
    
    struct Output {
        let articleDetails: Driver<ArticleDetails>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        Output(
            articleDetails: makeArticleDetails(),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension ArticleViewModel {
    func makeArticleDetails() -> Driver<ArticleDetails> {
        articleId
            .flatMapLatest { [weak self] articleId -> Driver<ArticleDetails> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<ArticleDetails> {
                    self.articlesManager
                        .obtainArticleDetails(id: articleId)
                        .map { articleDetails -> ArticleDetails in
                            guard let articleDetails else {
                                throw ContentError(.notContent)
                            }
                            
                            return articleDetails
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
