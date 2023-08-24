//
//  OCombineData.swift
//  Wicca
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import Foundation

struct OCombineData {
    let name: String
    let skillLevel: SkillLevel
    let weekSchedule: WeekSchedule
    let commandsGroupsIds: [Int]
}

final class OnboardingCombineData {
    private var name: String?
    private var skillLevel: SkillLevel?
    private var weekSchedule: WeekSchedule?
    private var commandsGroups: [CommandGroup]?
    
    func combineData() -> OCombineData? {
        guard
            let name = name,
            let skillLevel = skillLevel,
            let weekSchedule = weekSchedule,
            let commandsGroups = commandsGroups
        else {
            return nil
        }
        
        return OCombineData(
            name: name,
            skillLevel: skillLevel,
            weekSchedule: weekSchedule,
            commandsGroupsIds: commandsGroups.map { $0.id }
        )
    }
}

// MARK: ODogNameViewDelegate
extension OnboardingCombineData: ODogNameViewDelegate {
    func dogNameDidSet(name: String) {
        self.name = name
    }
}

// MARK: OSkillLevelViewDelegate
extension OnboardingCombineData: OSkillLevelViewDelegate {
    func skillLevelViewDidSelect(skillLevel: SkillLevel) {
        self.skillLevel = skillLevel
    }
}

// MARK: ODaysOfWeekViewDelegate
extension OnboardingCombineData: ODaysOfWeekViewDelegate {
    func daysOfWeekViewDidSelect(weekSchedule: WeekSchedule) {
        self.weekSchedule = weekSchedule
    }
}

// MARK: OCommandsViewDelegate
extension OnboardingCombineData: OCommandsViewDelegate {
    func didSelect(commandsGroups: [CommandGroup]) {
        self.commandsGroups = commandsGroups
    }
}
