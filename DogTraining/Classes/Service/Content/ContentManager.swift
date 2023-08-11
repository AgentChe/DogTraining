//
//  ContentManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

import RxSwift

protocol ContentManagerProtocol {
    func obtainLevels(forceUpdate: Bool) -> Single<[SkillLevel]>
    func obtainBreeds(forceUpdate: Bool) -> Single<[Breed]>
}

final class ContentManager {
    enum Constants {
        static let skillLevels = "content_manager_skill_levels_key"
        static let breeds = "content_manager_breeds_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: ContentManagerProtocol
extension ContentManager: ContentManagerProtocol {
    func obtainLevels(forceUpdate: Bool) -> Single<[SkillLevel]> {
        forceUpdate ? loadLevels() : cachedLevels()
    }
    
    func obtainBreeds(forceUpdate: Bool) -> Single<[Breed]> {
        forceUpdate ? loadBreeds() : cachedBreeds()
    }
}

// MARK: Private
private extension ContentManager {
    func loadLevels() -> Single<[SkillLevel]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetSkillLevelsRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetSkillLevelsResponse.map(from: $0) }
            .do(onSuccess: { levels in
                guard let data = try? JSONEncoder().encode(levels) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.skillLevels)
            })
    }
    
    func cachedLevels() -> Single<[SkillLevel]> {
        Single<[SkillLevel]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.skillLevels) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let levels = try? JSONDecoder().decode([SkillLevel].self, from: data)
            
            event(.success(levels ?? []))
            
            return Disposables.create()
        }
    }
    
    func loadBreeds() -> Single<[Breed]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetBreedsRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetBreedsResponse.map(from: $0) }
            .do(onSuccess: { levels in
                guard let data = try? JSONEncoder().encode(levels) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.breeds)
            })
    }
    
    func cachedBreeds() -> Single<[Breed]> {
        Single<[Breed]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.breeds) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let breeds = try? JSONDecoder().decode([Breed].self, from: data)
            
            event(.success(breeds ?? []))
            
            return Disposables.create()
        }
    }
}
