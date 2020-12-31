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
    @State var isEmojiView = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack {
                    HStack {
                        Group {
                            if isExpanded {
                                Text(selectedDate.localizedYearMonthDay)
                            } else {
                                Text(selectedDate.localizedMonthDay)
                            }
                        }
                        .foregroundColor(habit.color)
                        .headline()
                        Spacer()
                    }
                }
                .animation(nil)
                Spacer()
                Button(action: {
                    withAnimation {
                        isEmojiView.toggle()
                    }
                }) {
                    Image(systemName: isEmojiView ? "face.smiling.fill" : "face.smiling")
                        .subColor()
                        .headline()
                }
            }
            .padding(.horizontal, 20)
            CalendarRow(selectedDate: $selectedDate, isExpanded: $isExpanded, isEmojiView: $isEmojiView, move: move) { week, isExpanded in
                Group {
                    if isEmojiView {
                        CalendarWeek(week: week, selectedDate: $selectedDate) { date in
                            Button(action: { self.selectedDate = date }) {
                                VStack {
                                    Text(String(date.day))
                                        .foregroundColor(selectedDate.dictKey == date.dictKey ? habit.color : ThemeColor.mainColor(colorScheme))
                                        .bodyText()
                                    Text(habit.dailyEmoji[date.dictKey] ?? "")
                                        .headline()
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .opacity(selectedDate.month == date.month ? 1 : 0.5)
                        }
                    } else {
                        RingWeek(week: week, isExpanded: $isExpanded, habits: [habit], selectedDate: $selectedDate)
                    }
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
