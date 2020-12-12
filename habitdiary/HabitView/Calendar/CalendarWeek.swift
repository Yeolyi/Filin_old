//
//  CalendarWeek.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct CustomCalendarWeek: View {
    
    let week: Int
    let currentDate: Date
    @ObservedObject var habit: HabitInfo
    
    var firstDayofWeek: Int {
        let calendar = Calendar.current
        var dateComponents  = calendar.dateComponents([.year, .month], from: currentDate)
        dateComponents.day = 1
        return calendar.date(from: dateComponents)?.dayOfTheWeek ?? 1
    }
    var lastDayofWeek: Int {
        let calendar = Calendar.current
        var dateComponents  = calendar.dateComponents([.year, .month], from: currentDate)
        dateComponents.day = getMonthLength(year: currentDate.year, month: currentDate.month)
        return calendar.date(from: dateComponents)?.dayOfTheWeek ?? 1
    }
    var lineNum: Int {
        let date = currentDate
        let calendar = Calendar.current
        let weekRange = calendar.range(
            of: .weekOfMonth,
            in: .month,
            for: date
        )
        return weekRange?.count ?? 0
    }
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack {
            if week == 0 {
                ForEach(1..<8) { day in
                    CalendarUnit(
                        color: Color(str: habit.color),
                        progress: percentAchieved(day: firstDayofWeek <= day ? day-firstDayofWeek+1 : nil) ?? 0,
                        date: dayToDate(firstDayofWeek <= day ? day-firstDayofWeek+1 : nil),
                        isUnderline: isMemo(.first, day: day), currentDate: currentDate,
                        selectedDate: $selectedDate
                    )
                }
            } else if week == lineNum - 1 {
                ForEach(1..<8) { day in
                    CalendarUnit(
                        color: Color(str: habit.color),
                        progress: percentAchieved(day: lastDayofWeek >= day ? day+7*week-firstDayofWeek+1 : nil) ?? 0,
                        date: dayToDate(lastDayofWeek >= day ? day+7*week-firstDayofWeek+1 : nil),
                        isUnderline: isMemo(.last, day: day), currentDate: currentDate,
                        selectedDate: $selectedDate)
                }
            } else {
                ForEach(1..<8) { day in
                    CalendarUnit(
                        color: Color(str: habit.color),
                        progress: percentAchieved(day: day+7*week-firstDayofWeek+1) ?? 0,
                        date: dayToDate(day+7*week-firstDayofWeek+1),
                        isUnderline: isMemo(.middle, day: day), currentDate: currentDate,
                        selectedDate: $selectedDate)
                }
            }
        }
    }
    
    enum WeekType {
        case first, middle, last
    }
    
    func isMemo(_ weekType: WeekType, day: Int) -> Bool {
        func weekTypeToDay(_ weekType: WeekType, day: Int) -> Int? {
            switch(weekType) {
            case .first:
                return firstDayofWeek <= day ? day-firstDayofWeek+1 : nil
            case .last:
                return lastDayofWeek >= day ? day+7*week-firstDayofWeek+1 : nil
            case .middle:
                return day+7*week-firstDayofWeek+1
            }
        }
        if let realDay = weekTypeToDay(weekType, day: day) {
            if let day = dayToDate(realDay) {
                return habit.diary[day.dictKey] != nil
            }
        }
        return false
    }
    
    func getMonthLength(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func percentAchieved(day: Int?) -> Double? {
        if let day = day {
          let date = dayToDate(day) ?? currentDate
            guard habit.times > 0 else {
                return 1.0
            }
            return min(Double((habit.achieve[date.dictKey] ?? 0))/Double(habit.times), 1)
        } else {
            return nil
        }
    }
    
    func dayToDate(_ day: Int?) -> Date? {
        if day == nil {
            return nil
        }
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month], from: currentDate)
        dateComponents.day = day
        return calendar.date(from: dateComponents)
    }
}
