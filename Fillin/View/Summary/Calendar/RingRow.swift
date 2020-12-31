//
//  CustomCalendar.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct RingRow: View {
    
    @Binding var selectedDate: Date
    @ObservedObject var habits: CalendarHabitList
    @State var isExpanded = false
    @Environment(\.colorScheme) var colorScheme
    @State var isEmojiView = false
    var color: Color {
        let validHabits = habits.habits.compactMap{$0}
        if !validHabits.isEmpty {
            return validHabits[0].color
        } else {
            return ThemeColor.mainColor(colorScheme)
        }
    }
    
    init(selectedDate: Binding<Date>, habits: [Habit?], isExpanded: Bool = false) {
        self._selectedDate = selectedDate
        let calendarHabitList = CalendarHabitList(habits: habits)
        self.habits = calendarHabitList
        self._isExpanded = State(initialValue: isExpanded)
    }
    
    var body: some View {
        VStack {
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
                        .foregroundColor(color)
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
            CalendarRow(selectedDate: $selectedDate, isExpanded: $isExpanded, isEmojiView: $isEmojiView, move: move, content: { week, isExpanded in
                Group {
                    if isEmojiView && !habits.habits.compactMap{$0}.isEmpty{
                        CalendarWeek(week: week, selectedDate: $selectedDate) { date in
                            Button(action: { self.selectedDate = date }) {
                                VStack {
                                    Text(String(date.day))
                                        .foregroundColor(selectedDate.dictKey == date.dictKey ? color : ThemeColor.mainColor(colorScheme))
                                        .bodyText()
                                    Text(habits.habits.compactMap{$0}[0].dailyEmoji[date.dictKey] ?? "")
                                        .headline()
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .opacity(selectedDate.month == date.month ? 1 : 0.5)
                        }
                    } else {
                        RingWeek(week: week, isExpanded: $isExpanded, habits: habits.habits, selectedDate: $selectedDate)
                    }
                }
            })
        }
    }
    
    func move(isAdd: Bool) -> Date {
        let habit = habits.habits.compactMap({$0}).first
        let addedValue = isAdd ?  1 : -1
        if isExpanded {
            guard let habit = habit else {
                return Calendar.current.date(byAdding: .month, value: addedValue, to: selectedDate) ?? Date()
            }
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

/*
 struct CustomCalendar_Previews: PreviewProvider {
 static var previews: some View {
 CalendarRow(selectedDate: .constant(Date()), habit: , isExpanded: true)
 }
 }
 */
