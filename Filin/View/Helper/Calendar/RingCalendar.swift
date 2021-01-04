//
//  CustomCalendar.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct RingCalendar: View {
    
    @Binding var selectedDate: Date
    @ObservedObject var habitsWrapped: CalendarHabitWrapper
    @State var isExpanded = false
    @Environment(\.colorScheme) var colorScheme
    @State var isEmojiView = false
    
    var color: Color {
        if habitsWrapped.compact.isEmpty {
            return ThemeColor.mainColor(colorScheme)
        } else {
            return habitsWrapped.compact[0].color
        }
    }
    
    init(selectedDate: Binding<Date>, habits: [Habit?], isExpanded: Bool = false) {
        self._selectedDate = selectedDate
        let calendarHabitList = CalendarHabitWrapper(habits: habits)
        self.habitsWrapped = calendarHabitList
        self._isExpanded = State(initialValue: isExpanded)
    }
    
    var body: some View {
        CalendarInterface(selectedDate: $selectedDate, color: color, isExpanded: $isExpanded, isEmojiView: $isEmojiView, move: move, content: { week, isExpanded in
            Group {
                if isEmojiView && !habitsWrapped.compact.isEmpty {
                    EmojiCalendarRow(week: week, isExpanded: isExpanded, habit: habitsWrapped.compact[0], selectedDate: $selectedDate)
                } else {
                    RingWeek(week: week, isExpanded: isExpanded, habits: habitsWrapped.value, selectedDate: $selectedDate)
                }
            }
        })
    }
    
    func move(isAdd: Bool) -> Date {
        let habit = habitsWrapped.value.compactMap({$0}).first
        let addedValue = isAdd ?  1 : -1
        if isExpanded {
            guard let habit = habit else {
                return Calendar.current.date(byAdding: .month, value: addedValue, to: selectedDate) ?? Date()
            }
            if !habit.isDaily {
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
