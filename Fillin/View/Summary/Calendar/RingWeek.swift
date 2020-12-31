//
//  CalendarWeek.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct RingWeek: View {
    @Environment(\.colorScheme) var colorScheme
    let week: Int
    @Binding var isExpanded: Bool
    let ringNum: Int
    @ObservedObject var habits: CalendarHabitList
    @Binding var selectedDate: Date
    var body: some View {
        CalendarWeek(week: week, selectedDate: $selectedDate) { date in
            Group {
                if isButtonActive(at: date) {
                    CircleProgress(getRingTuple(at: date)) {
                        Text(Date().dictKey == date.dictKey ? "✓" : String(date.day))
                            .foregroundColor(textColor(at: date))
                            .bodyText()
                    }
                    .onTapGesture {
                        selectedDate = date
                    }
                } else {
                    CircleProgress([nil]) {
                        Text(Date().dictKey == date.dictKey ? "✓" : String(date.day))
                            .subColor()
                            .bodyText()
                    }
                }
            }
        }
        .padding(.bottom, 10)
    }
    init(week: Int, isExpanded: Binding<Bool>, habits: [Habit?], selectedDate: Binding<Date>) {
        self.week = week
        self._isExpanded = isExpanded
        self.habits = CalendarHabitList(habits: habits)
        self._selectedDate = selectedDate
        self.ringNum = habits.compactMap {$0}.count
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
        if ringNum == 0 || habits.habits.count > 1 {
            return true
        } else {
            return habits.habits[0]?.cycleType == HabitCycleType.daily
                || habits.habits[0]?.dayOfWeek.contains(Int16(date.dayOfTheWeek)) == true
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
