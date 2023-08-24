//
//  SettingsViewController.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import UIKit
import RxCocoa
import RxSwift

final class SettingsViewController: UIViewController {
    lazy var mainView = SettingsView()
    
    private lazy var viewModel = SettingsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SettingsViewModel.Input(
            didSelectElement: mainView.tableView.didSelectItem
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
        
        output.dogName
            .drive(Binder(self) { base, name in
                base.navigationItem.title = String(format: "Profile.Settings".localized, name)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SettingsViewController {
    static func make() -> SettingsViewController {
        SettingsViewController()
    }
}

// MARK: Private
private extension SettingsViewController {
    // TODO
    func route(_ route: SettingsViewModel.Route) {
        switch route {
        case .skillLevel(let level):
            break
//            let vc = ProfileEditViewController.make(skillLevel: level)
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true)
        case .trainingDays(let weekSchedule):
            break
//            let vc = ProfileEditViewController.make(weekSchedule: weekSchedule)
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true)
        case .commandsGroups(let commandsGroups):
            break
//            let vc = ProfileEditViewController.make(focusZones: zones, gender: gender)
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true)
        case .dogName(let dogName):
            break
        case .open(let url):
            if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
