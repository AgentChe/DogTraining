//
//  OnboardingView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingView: UIView {
    enum Step: Int {
        case welcome, role, breed, dogName, age, skillLevel, behavior, daysOfWeek, whereTrain, commands, topics, preloader
    }
    
    var didFinish: (() -> Void)?
    
    private lazy var nameView = ODogNameView(step: .dogName)
    private lazy var skillLevelView = OSkillLevelView(step: .skillLevel)
    private lazy var daysOfWeekView = ODaysOfWeekView(step: .daysOfWeek)
    private lazy var commandsView = OCommandsView(step: .commands)
    private lazy var preloaderView = OPreloaderView(step: .preloader, combineData: combineData)
    
    private lazy var contentViews: [OSlideView] = {
        [
            OWelcomeView(step: .welcome),
            ORoleView(step: .role),
            OBreedView(step: .breed),
            nameView,
            OAgeView(step: .age),
            skillLevelView,
            OBehaviorView(step: .behavior),
            daysOfWeekView,
            OWhereTrainView(step: .whereTrain),
            commandsView,
            OTopicsView(step: .topics),
            preloaderView
        ]
    }()
    
    private var step = Step.welcome
    
    private lazy var combineData = OnboardingCombineData()
    
    private weak var vc: UIViewController?
    
    init(vc: UIViewController) {
        self.vc = vc
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: OSlideViewDelegate
extension OnboardingView: OSlideViewDelegate {
    func slideViewDidNext(from step: Step) {
        let nextRawValue = step.rawValue + 1
        
        guard let nextStep = Step(rawValue: nextRawValue) else {
            didFinish?()
            
            return
        }
        
        scroll(to: nextStep)
    }
    
    func slideViewDidBack(from step: OnboardingView.Step) {
        let previousRawValue = step.rawValue - 1
        
        guard let previousStep = Step(rawValue: previousRawValue) else {
            return
        }
        
        scroll(to: previousStep)
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        contentViews
            .enumerated()
            .forEach { [weak self] index, view in
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
                
                view.clipsToBounds = true
                view.delegate = self
                
                if index == 0 {
                    view.frame.origin = CGPoint(x: 0, y: 0)
                    addSubview(view)
                }
            }
        
        nameView.mainDelegate = combineData
        skillLevelView.mainDelegate = combineData
        daysOfWeekView.mainDelegate = combineData
        commandsView.mainDelegate = combineData
        preloaderView.vc = vc
    }
    
    func scroll(to newStep: Step) {
        let currentIndex = step.rawValue
        let scrollToIndex = newStep.rawValue
        
        let direction = scrollToIndex > currentIndex ? 1 : -1
        
        let indices = contentViews.indices
        
        guard indices.contains(currentIndex), indices.contains(scrollToIndex) else {
            return
        }

        let currentView = contentViews[currentIndex]
        let scrollToView = contentViews[scrollToIndex]
        
        scrollToView.frame.origin = CGPoint(x: 375.scale * CGFloat(direction), y: 0)
        addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: {
            currentView.frame.origin = CGPoint(x: 375.scale * CGFloat(-direction), y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            
            currentView.removeFromSuperview()
            
            scrollToView.moveToThis()
            
            self.step = newStep
        })
    }
}
