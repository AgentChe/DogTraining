//
//  ProfileEditViewController.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditViewController: UIViewController {
    lazy var mainView = ProfileEditView()
    
    private lazy var viewModel = ProfileEditViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    init(skillLevel: SkillLevel?) {
        super.init(nibName: nil, bundle: nil)
        
        let content = ProfileEditSkillLevelView(skillLevel: skillLevel)
        content.didSave = { [weak self] skillLevel in
            self?.viewModel.didSaveSkillLevel.accept(skillLevel)
        }
        self.mainView.setup(contentView: content)
    }
    
    init(weekSchedule: WeekSchedule?) {
        super.init(nibName: nil, bundle: nil)
        
        let content = ProfileEditDaysOfWeekView(weekSchedule: weekSchedule)
        content.didSave = { [weak self] weekSchedule in
            self?.viewModel.didSaveWeekSchedule.accept(weekSchedule)
        }
        mainView.setup(contentView: content)
    }
    
    init(commandsGroups: [CommandGroup]) {
        super.init(nibName: nil, bundle: nil)
        
        let content = ProfileEditCommandsGroupsView(commandsGroups: commandsGroups)
        content.didSave = { [weak self] commandsGroups in
            self?.viewModel.didSaveCommandsGroups.accept(commandsGroups)
        }
        mainView.setup(contentView: content)
    }
    
    init(dogName: String?) {
        super.init(nibName: nil, bundle: nil)
        
        let content = ProfileEditNameView(dogName: dogName)
        content.didSave = { [weak self] dogName in
            self?.viewModel.didSaveName.accept(dogName)
        }
        mainView.setup(contentView: content)
    }
    
    override func loadView() {
        view = mainView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        let output = viewModel.configure(input: ProfileEditViewModel.Input())
        
        Signal
            .merge(
                output.saved,
                mainView.closeButton.rx.tap.asSignal()
            )
            .emit(with: self) { base, _ in
                base.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ProfileEditViewController {
    static func make(skillLevel: SkillLevel?) -> ProfileEditViewController {
        let vc = ProfileEditViewController(skillLevel: skillLevel)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func make(weekSchedule: WeekSchedule?) -> ProfileEditViewController {
        let vc = ProfileEditViewController(weekSchedule: weekSchedule)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func make(commandsGroups: [CommandGroup]) -> ProfileEditViewController {
        let vc = ProfileEditViewController(commandsGroups: commandsGroups)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func make(dogName: String?) -> ProfileEditViewController {
        let vc = ProfileEditViewController(dogName: dogName)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension ProfileEditViewController {
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
    
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
