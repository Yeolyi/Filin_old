//
//  CalendarWeek.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct CustomCalendarWeek: View {
    @Environment(\.colorScheme) var colorScheme
    let week: Int
    let isExpanded: Bool
    let dateList: [Date]
    let ringNum: Int
    @ObservedObject var habits: CalendarHabitList
    @Binding var selectedDate: Date
    var body: some View {
        HStack {
            ForEach(dateList, id: \.self) { date in
                if isButtonActive(at: date) {
                    Button(action: {selectedDate = date}) {
                        CircleProgress(getRingTuple(at: date)) {
                            Text(Date().dictKey == date.dictKey ? "✓" : String(date.day))
                                .foregroundColor(textColor(at: date))
                        }
                    }
                } else {
                    CircleProgress([nil]) {
                        Text(Date().dictKey == date.dictKey ? "✓" : String(date.day))
                            .subColor()
                    }
                }
            }
        }
    }
    init(week: Int, isExpanded: Bool, habits: [Habit?], selectedDate: Binding<Date>) {
        self.week = week
        self.isExpanded = isExpanded
        self.habits = CalendarHabitList(habits: habits)
        self._selectedDate = selectedDate
        self.ringNum = habits.compactMap {$0}.count
        var tempDateList: [Date] = []
        let firstDayOfWeek = selectedDate.wrappedValue.firstDayOfWeek ?? 1
        for diff in 1 - firstDayOfWeek ..< 8 - firstDayOfWeek {
            let newDate = Calendar.current.date(
                byAdding: .day,
                value: diff + 7 * (week - 1),
                to: selectedDate.wrappedValue.firstDayOfMonth ?? Date()
            ) ?? Date()
            tempDateList.append(newDate)
        }
        dateList = tempDateList
    }
    func getRingTuple(at date: Date) -> [(Double, Color)?] {
        var tempRingTuple: [(Double, Color)?] = []
        for habit in habits.habits {
            guard let habit = habit else {
                tempRingTuple.append(nil)
                continue
            }
            guard let progress = habit.progress(at: date), progress > 0 else {
                tempRingTuple.append(nil)
                continue
            }
            let color = (selectedDate.month == date.month) ? habit.color : ThemeColor.subColor(colorScheme)
            tempRingTuple.append((progress, color))
        }
        if ringNum > 1 && tempRingTuple.compactMap({$0}).isEmpty {
            let colorInactive = ThemeColor.subColor(colorScheme).opacity(0.2)
            tempRingTuple.append((1, colorInactive))
        }
        return tempRingTuple
    }
    func isButtonActive(at date: Date) -> Bool {
        if !isExpanded || ringNum == 0 || habits.habits.count > 1 {
            return true
        } else {
            return habits.habits[0]?.cycleType == HabitCycleType.daily
                || habits.habits[0]?.dayOfWeek?.contains(Int16(date.dayOfTheWeek)) == true
        }
    }
    func textColor(at date: Date) -> Color {
        if selectedDate.month != date.month && isExpanded {
            return ThemeColor.subColor(colorScheme)
        } else if ringNum == 0 {
            return ThemeColor.mainColor(colorScheme)
        } else if date.dictKey == selectedDate.dictKey {
            if let colorHex = habits.habits[0]?.color {
                return colorHex
            } else {
                return ThemeColor.subColor(colorScheme)
            }
        }
        return ThemeColor.mainColor(colorScheme)
    }
}
