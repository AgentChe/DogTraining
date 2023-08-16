//
//  GameTrainingViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import RxSwift
import RxCocoa

final class GameTrainingViewModel {
    enum Route {
        case finished(GameTraining)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didFinishTraining = PublishRelay<Int>()
    
    lazy var activity = RxActivityIndicator()
    lazy var route = makeRoute()
    lazy var startTraining = makeStartTraining()
    lazy var game = makeGame()
    
    private lazy var gameTraining = makeGameTraining()
    private let customerGameId: Driver<Int>
    
    private lazy var gamesManager = GamesManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(customerGameId: Int) {
        self.customerGameId = BehaviorRelay(value: customerGameId).asDriver()
    }
}

// MARK: Private
private extension GameTrainingViewModel {
    func makeRoute() -> Driver<Route> {
        didFinishTraining
            .withLatestFrom(gameTraining) { ($0, $1) }
            .flatMapLatest { [weak self] totalSeconds, gameTraining -> Observable<GameTraining> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<GameTraining> {
                    self.gamesManager
                        .logProgress(
                            customerGameId: gameTraining.assignedGame.customerGameId,
                            trainedTime: totalSeconds,
                            finish: true
                        )
                        .flatMap { assignedGame -> Single<GameTraining> in
                            guard let assignedGame = assignedGame else {
                                return .error(ContentError(.notContent))
                            }
                            
                            let result = GameTraining(
                                game: gameTraining.game,
                                assignedGame: assignedGame
                            )
                            return .just(result)
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
            }
            .map { Route.finished($0) }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeStartTraining() -> Signal<Void> {
        gameTraining
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .never())
    }
    
    func makeGame() -> Driver<Game> {
        gameTraining
            .map { $0.game }
    }
    
    func makeGameTraining() -> Driver<GameTraining> {
        customerGameId
            .flatMapLatest { [weak self] customerGameId -> Driver<GameTraining> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<GameTraining> {
                    self.gamesManager
                        .obtainGameTraining(customerGameId: customerGameId)
                        .flatMap { gameTraining -> Single<GameTraining> in
                            guard let gameTraining = gameTraining else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(gameTraining)
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
