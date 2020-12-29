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
    
    init(selectedDate: Binding<Date>, habits: [Habit?], isExpanded: Bool = false) {
        self._selectedDate = selectedDate
        let calendarHabitList = CalendarHabitList(habits: habits)
        self.habits = calendarHabitList
        self._isExpanded = State(initialValue: isExpanded)
    }
    
    var body: some View {
        CalendarRow(selectedDate: $selectedDate, isExpanded: $isExpanded, move: move) { week, isExpanded in
            RingWeek(week: week, isExpanded: $isExpanded, habits: habits.habits, selectedDate: $selectedDate)
                .padding(.bottom, 10)
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
