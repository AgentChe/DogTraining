//
//  ArticlesManager.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 21.08.2023.
//

import RxSwift

protocol ArticlesManagerProtocol {
    func obtainArticles(forceUpdate: Bool) -> Single<[Article]>
    func obtainArticleDetails(id: Int) -> Single<ArticleDetails?>
}

final class ArticlesManager {
    enum Constants {
        static let articlesKey = "articles_manager_articles_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
}

// MARK: ArticlesManagerProtocol
extension ArticlesManager: ArticlesManagerProtocol {
    func obtainArticles(forceUpdate: Bool) -> Single<[Article]> {
        forceUpdate ? loadArticles() : cachedArticles()
    }
    
    func obtainArticleDetails(id: Int) -> Single<ArticleDetails?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetArticleDetailsRequest(userToken: userToken, id: id)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetArticleDetailsResponse.map(from: $0) }
    }
}

// MARK: Private
private extension ArticlesManager {
    func loadArticles() -> Single<[Article]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetArticlesRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetArticlesResponse.map(from: $0) }
            .do(onSuccess: { articles in
                guard let data = try? JSONEncoder().encode(articles) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.articlesKey)
            })
    }
    
    func cachedArticles() -> Single<[Article]> {
        Single<[Article]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.articlesKey) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let articles = try? JSONDecoder().decode([Article].self, from: data)
            
            event(.success(articles ?? []))
            
            return Disposables.create()
        }
    }
}
