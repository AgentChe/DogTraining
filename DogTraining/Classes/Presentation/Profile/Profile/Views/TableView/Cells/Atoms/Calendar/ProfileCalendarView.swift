//
//  ProfileCalendarView.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 29.08.2023.
//

import UIKit
import JTAppleCalendar

final class ProfileCalendarView: JTACMonthView {
    private var didSelectDate: ((Date) -> Void)?

    override init() {
        super.init()
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProfileCalendarView {
    func setup(didSelectDate: @escaping (Date) -> Void) {
        self.didSelectDate = didSelectDate
        
        reloadData()
    }
}

// MARK: JTACMonthViewDataSource
extension ProfileCalendarView: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let startDate = calendar.date(byAdding: .year, value: -2, to: currentDate) ?? currentDate
        let endDate = calendar.date(byAdding: .year, value: 2, to: currentDate) ?? currentDate
        
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 1,
            firstDayOfWeek: .sunday
        )
    }
}

// MARK: JTACMonthViewDelegate
extension ProfileCalendarView: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: String(describing: ProfileCalendarDayCell.self), for: indexPath) as! ProfileCalendarDayCell
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? ProfileCalendarDayCell else { return }
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? ProfileCalendarDayCell else { return }
        cell.setup(isSelected: cellState.isSelected)
        didSelectDate?(date)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? ProfileCalendarDayCell else { return }
        cell.setup(isSelected: cellState.isSelected)
    }
}

// MARK: Private
private extension ProfileCalendarView {
    func initialize() {
        scrollDirection = .horizontal
        calendarDelegate = self
        calendarDataSource = self
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        scrollingMode = .stopAtEachCalendarFrame
        register(ProfileCalendarDayCell.self, forCellWithReuseIdentifier: String(describing: ProfileCalendarDayCell.self))
    }
    
    func configureCell(cell: ProfileCalendarDayCell, cellState: CellState) {
        cell.setup(isCurrentDay: Calendar.current.compare(cellState.date, to: Date(), toGranularity: .day) == .orderedSame)
        cell.setup(text: cellState.text, weekDay: cellState.day)
        cell.setup(isSelected: cellState.isSelected)
    }
}
