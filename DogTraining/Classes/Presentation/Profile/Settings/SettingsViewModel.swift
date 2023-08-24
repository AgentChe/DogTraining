//
//  SettingsViewModel.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 24.08.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingsViewModel {
    enum Route {
        case skillLevel(SkillLevel?)
        case trainingDays(WeekSchedule?)
        case commandsGroups([CommandGroup])
        case dogName(String?)
        case open(url: String)
    }
    
    private lazy var editableData = makeEditableData()
    
    private lazy var profileManager = ProfileManager()
    private lazy var contentManager = ContentManager()
    private lazy var commandsManager = CommandsManager()
}

// MARK: Public
extension SettingsViewModel {
    struct Input {
        let didSelectElement: Signal<SettingsTableElement>
    }
    
    struct Output {
        let elements: Driver<[SettingsTableElement]>
        let route: Driver<Route>
        let dogName: Driver<String>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(),
            route: makeRoute(didSelectElement: input.didSelectElement),
            dogName: editableData.map { $0.dogName ?? "" }
        )
    }
}

// MARK: Private
private extension SettingsViewModel {
    struct EditableData {
        let level: SkillLevel?
        let weekSchedule: WeekSchedule?
        let commandsGroups: [CommandGroup]
        let dogName: String?
    }
    
    func makeRoute(didSelectElement: Signal<SettingsTableElement>) -> Driver<Route> {
        didSelectElement
            .asObservable()
            .withLatestFrom(editableData.asObservable()) { ($0, $1) }
            .compactMap { item, data -> Route? in
                guard case let .item(cellType, _, _) = item else { return nil }
                
                switch cellType {
                case .skillLevel:
                    return .skillLevel(data.level)
                case .trainingDays:
                    return .trainingDays(data.weekSchedule)
                case .commandsGroups:
                    return .commandsGroups(data.commandsGroups)
                case .dogName:
                    return .dogName(data.dogName)
                case .termsOfUse:
                    return .open(url: GlobalDefinitions.termsOfServiceUrl)
                case .privatePolicy:
                    return .open(url: GlobalDefinitions.privacyPolicyUrl)
                case .contactUs:
                    return .open(url: GlobalDefinitions.contactUsUrl)
                }
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeEditableData() -> Driver<EditableData> {
        let profile = profileManager
            .obtainProfile(forceUpdate: false)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
        
        let currentLevel = Driver
            .merge(
                ProfileMediator.shared.skillLevelIdChange.map { $0 }.asDriver(onErrorDriveWith: .never()),
                profile.map { $0.skillLevelId }
            )
        
        let level = Driver
            .combineLatest(
                contentManager.obtainLevels(forceUpdate: false).asDriver(onErrorJustReturn: []),
                currentLevel
            ) { levels, currentId in
                levels.first(where: { $0.id == currentId })
            }
        
        let weekSchedule = Driver<WeekSchedule?>
            .merge(
                profile.map { $0.weekSchedule },
                ProfileMediator.shared.weekScheduleChange.map { $0 }.asDriver(onErrorDriveWith: .never())
            )
        
        let commandsGroupsIds = Driver
            .merge(
                profile.map { $0.commandGroupIds ?? [] },
                ProfileMediator.shared.commandGroupIdsChange.asDriver(onErrorJustReturn: [])
            )
        
        let commandsGroups = Driver
            .combineLatest(
                commandsManager.obtainCommandsGroups(forceUpdate: false).asDriver(onErrorJustReturn: []),
                commandsGroupsIds
            ) { commandsGroups, commandsGroupsIds in
                commandsGroupsIds
                    .compactMap { id in
                        commandsGroups.first(where: { $0.id == id })
                    }
            }
        
        return Driver
            .combineLatest(level, weekSchedule, commandsGroups, profile.map { $0.name }) {
                EditableData(level: $0, weekSchedule: $1, commandsGroups: $2, dogName: $3)
            }
    }
    
    func makeElements() -> Driver<[SettingsTableElement]> {
        editableData
            .map { value -> [SettingsTableElement] in
                let trainingDaysSubtitle = value.weekSchedule?.daysString
                let commandsGroupsSubtitle = value.commandsGroups.map { $0.name }.joined(separator: ", ")
                
                return [
                    .item(type: .skillLevel, subtitle: value.level?.name),
                    .item(type: .trainingDays, subtitle: trainingDaysSubtitle),
                    .item(type: .commandsGroups, subtitle: commandsGroupsSubtitle),
                    .item(type: .dogName, isLast: true, subtitle: value.dogName),
                    .header("Profile.Legal&Privacy".localized),
                    .item(type: .termsOfUse),
                    .item(type: .privatePolicy),
                    .item(type: .contactUs, isLast: true)
                ]
            }
            .asDriver(onErrorJustReturn: [])
    }
}

// MARK: Additional
private extension WeekSchedule {
    var daysString: String {
        [
            su ? "Onboarding.DaysOfWeek.Su".localized : nil,
            mo ? "Onboarding.DaysOfWeek.Mo".localized : nil,
            tu ? "Onboarding.DaysOfWeek.Tu".localized : nil,
            we ? "Onboarding.DaysOfWeek.We".localized : nil,
            th ? "Onboarding.DaysOfWeek.Th".localized : nil,
            fr ? "Onboarding.DaysOfWeek.Fr".localized : nil,
            sa ? "Onboarding.DaysOfWeek.Sa".localized : nil
        ]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
