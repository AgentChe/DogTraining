//
//  ProfileCalendarDayCell.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 29.08.2023.
//

import UIKit
import JTAppleCalendar

final class ProfileCalendarDayCell: JTACDayCell {
    lazy var weekDayLabel = makeLabel()
    lazy var dayLabel = makeLabel()
    lazy var daySelectView = makeDaySelectView()
    
    private lazy var dayAttrs = TextAttributes()
        .textColor(Appearance.black)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(25.6.scale)
        .textAlignment(.center)
    private lazy var weekDayAttrs = TextAttributes()
        .font(Fonts.Inter.regular(size: 12.scale))
        .lineHeight(16.scale)
        .textAlignment(.center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProfileCalendarDayCell {
    func setup(isSelected: Bool) {
        daySelectView.layer.borderWidth = isSelected ? 2.scale : 0
        daySelectView.layer.borderColor = isSelected ? Appearance.secondary.cgColor : UIColor.clear.cgColor
    }
    
    func setup(isCurrentDay: Bool) {
        daySelectView.backgroundColor = isCurrentDay ? Appearance.white : UIColor.clear
        weekDayLabel.textColor = isCurrentDay ? Appearance.secondary : Appearance.black.withAlphaComponent(0.7)
    }
    
    func setup(text: String, weekDay: DaysOfWeek) {
        dayLabel.attributedText = text.attributed(with: dayAttrs)
        weekDayLabel.attributedText = weekDay.dayName.attributed(with: weekDayAttrs)
    }
}

// MARK: Make constraints
private extension ProfileCalendarDayCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            weekDayLabel.topAnchor.constraint(equalTo: topAnchor),
            weekDayLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            daySelectView.widthAnchor.constraint(equalToConstant: 40.scale),
            daySelectView.heightAnchor.constraint(equalToConstant: 40.scale),
            daySelectView.centerXAnchor.constraint(equalTo: centerXAnchor),
            daySelectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: daySelectView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: daySelectView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileCalendarDayCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDaySelectView() -> CircleView {
        let view = CircleView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension JTAppleCalendar.DaysOfWeek {
    var dayName: String {
        switch self {
        case .sunday:
            return "Profile.DaysOfWeek.Su".localized
        case .monday:
            return "Profile.DaysOfWeek.Mo".localized
        case .tuesday:
            return "Profile.DaysOfWeek.Tu".localized
        case .wednesday:
            return "Profile.DaysOfWeek.We".localized
        case .thursday:
            return "Profile.DaysOfWeek.Th".localized
        case .friday:
            return "Profile.DaysOfWeek.Fr".localized
        case .saturday:
            return "Profile.DaysOfWeek.Sa".localized
        }
    }
}
