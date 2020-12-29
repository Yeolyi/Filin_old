//
//  HabitCalendar.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

struct HabitCalendar: View {
    @Binding var selectedDate: Date
    @ObservedObject var habit: Habit
    @State var isExpanded = false
    @Binding var isEmojiView: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        CalendarRow(selectedDate: $selectedDate, isExpanded: $isExpanded, move: move) { week, isExpanded in
            Group {
                if isEmojiView {
                    CalendarWeek(week: week, selectedDate: $selectedDate) { date in
                        Button(action: { self.selectedDate = date }) {
                            VStack {
                                Text(String(date.day))
                                    .foregroundColor(selectedDate == date ? habit.color : ThemeColor.mainColor(colorScheme))
                                Text(habit.dailyEmoji[date.dictKey] ?? "")
                                    .font(.system(size: 25))
                                    .frame(width: 40, height: 40)
                            }
                        }
                        .opacity(selectedDate.month == date.month ? 1 : 0.5)
                    }
                } else {
                    RingWeek(week: week, isExpanded: $isExpanded, habits: [habit], selectedDate: $selectedDate)
                        .padding(.bottom, 10)
                }
            }
        }
    }
    
    func move(isAdd: Bool) -> Date {
        let addedValue = isAdd ?  1 : -1
        if isExpanded {
            if habit.cycleType == HabitCycleType.weekly {
                return selectedDate.monthShift(contains: habit.dayOfWeek, isAdd: isAdd)
            } else {
                return Calendar.current.date(byAdding: .month, value: addedValue, to: selectedDate) ?? Date()
            }
        } else {
            return Calendar.current.date(byAdding: .weekOfMonth, value: addedValue, to: selectedDate) ?? Date()
        }
    }
    
}
