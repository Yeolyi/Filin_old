//
//  CalendarWeek.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct CustomCalendarWeek: View {
    
    let week: Int
    let isExpanded: Bool
    @ObservedObject var habit: HabitInfo
    @Binding var selectedDate: Date
    
    var firstDayofWeek: Int {
        let calendar = Calendar.current
        var dateComponents  = calendar.dateComponents([.year, .month], from: selectedDate)
        dateComponents.day = 1
        return calendar.date(from: dateComponents)?.dayOfTheWeek ?? 1
    }
    var lastDayofWeek: Int {
        let calendar = Calendar.current
        var dateComponents  = calendar.dateComponents([.year, .month], from: selectedDate)
        dateComponents.day = getMonthLength(year: selectedDate.year, month: selectedDate.month)
        return calendar.date(from: dateComponents)?.dayOfTheWeek ?? 1
    }
    
    var body: some View {
        HStack {
            ForEach(1..<8) { day in
                if habit.habitType == HabitType.daily.rawValue || habit.targetDays?.contains(Int16(day)) == true {
                    CalendarUnit(
                        color: (monthTypef(weekNum: week, dayOfWeek: day) != .this) && isExpanded == true ? Color.gray.opacity(0.1) : Color(hex: habit.color),
                        progress: percentAchieved(date: dayOfWeekToDate(weekNum: week, dayOfWeek: day)),
                        date: dayOfWeekToDate(weekNum: week, dayOfWeek: day),
                        isUnderline: habit.diary[dayOfWeekToDate(weekNum: week, dayOfWeek: day).dictKey] != nil,
                        isActivated: (monthTypef(weekNum: week, dayOfWeek: day) != .this) ? false : true,
                        selectedDate: $selectedDate
                    )
                } else {
                    CalendarUnit(
                        color: Color.gray.opacity(0.1),
                        progress: 0,
                        date: dayOfWeekToDate(weekNum: week, dayOfWeek: day),
                        isUnderline: false,
                        isActivated: false,
                        selectedDate: $selectedDate
                    )
                    .disabled(true)
                }
            }
        }
    }
    
    enum WeekType {
        case first, middle, last
    }
    enum MonthType {
        case previous, this, next
    }
    
    func weekTypef(_ weekNum: Int) -> WeekType {
        let date = selectedDate
        let calendar = Calendar.current
        let lineNum = calendar.range(
            of: .weekOfMonth,
            in: .month,
            for: date
        )?.count ?? 0
        if weekNum == 1 {
            return .first
        } else if weekNum == lineNum {
            return .last
        } else {
            return .middle
        }
    }
    
    func monthTypef(weekNum: Int, dayOfWeek: Int) -> MonthType {
        let weekType = weekTypef(weekNum)
        if weekType == .first && dayOfWeek < firstDayofWeek {
            return .previous
        } else if weekType == .last && dayOfWeek > lastDayofWeek {
            return .next
        } else {
            return .this
        }
    }
    
    func dayOfWeekToDate(weekNum: Int, dayOfWeek: Int) -> Date {
        let weekType = weekTypef(weekNum)
        let monthType = monthTypef(weekNum: weekNum, dayOfWeek: dayOfWeek)
        let calendar = Calendar.current
        var dateComponents: DateComponents
        dateComponents = calendar.dateComponents([.year, .month], from: selectedDate)
        switch(monthType) {
        case .previous:
            if dateComponents.month != nil {
                dateComponents.month = dateComponents.month! - 1
            }
        case .this:
            break
        case .next:
            if dateComponents.month != nil {
                dateComponents.month = dateComponents.month! + 1
            }
        }
        let day: Int?
        switch(weekType) {
        case .first:
            day = firstDayofWeek <= dayOfWeek ? dayOfWeek-firstDayofWeek+1 : getMonthLength(year: selectedDate.year, month: selectedDate.month-1)-firstDayofWeek+dayOfWeek+1
        case .last:
            day = lastDayofWeek >= dayOfWeek ? dayOfWeek+7*(week-1)-firstDayofWeek+1 : dayOfWeek - lastDayofWeek
        case .middle:
            day = dayOfWeek+7*(week-1)-firstDayofWeek+1
        }
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? Date()
    }
    
    func getMonthLength(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func percentAchieved(date: Date) -> Double {
        Double((habit.achieve[date.dictKey] ?? 0))/Double(habit.targetAmount)
    }
}
