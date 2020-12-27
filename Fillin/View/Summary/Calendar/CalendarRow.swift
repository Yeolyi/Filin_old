//
//  CustomCalendar.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

class CalendarHabitList: ObservableObject {
    @Published var habits: [Habit?] = []
    init(habits: [Habit?]) {
        self.habits = habits
    }
}

struct CalendarRow: View {
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
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Spacer()
                    Group {
                        if isExpanded {
                            Text(selectedDate.localizedYearMonth)
                        } else {
                            Text(selectedDate.localizedMonthDay)
                        }
                    }
                    .rowHeadline()
                    .animation(nil)
                    Spacer()
                }
                HStack {
                    Spacer()
                    moveButton(isAdd: false)
                    moveButton(isAdd: true)
                }
            }
            .padding(.bottom, 15)
            HStack {
                ForEach(1...7, id: \.self) { dayOfWeek in
                    Text(Date.dayOfTheWeekStr(dayOfWeek))
                        .rowSubheadline()
                        .foregroundColor(.gray)
                        .frame(width: 40)
                }
            }
            .padding(.bottom, 8)
            if isExpanded {
                ForEach(1..<(selectedDate.weekInMonth ?? 2) + 1, id: \.self) { week in
                    CustomCalendarWeek(week: week, isExpanded: true, habits: habits.habits, selectedDate: $selectedDate)
                        .padding(.bottom, 10)
                }
            } else {
                CustomCalendarWeek(
                    week: selectedDate.weekNum, isExpanded: false, habits: habits.habits, selectedDate: $selectedDate
                )
                .padding(.bottom, 10)
            }
            expandCalendarButton
        }
        .rowBackground()
    }
    var expandCalendarButton: some View {
        Button(action: {
            withAnimation {
                self.isExpanded.toggle()
            }
        }) {
            Image(systemName: isExpanded ? "chevron.compact.up" : "chevron.compact.down")
                .font(.system(size: 20))
                .frame(width: 30, height: 30)
                .subColor()
        }
        .padding(5)
    }
    func moveButton(isAdd: Bool) -> some View {
        Button(action: {
            let habit = habits.habits.compactMap({$0}).first
            let addedValue = isAdd ?  1 : -1
            withAnimation {
                if isExpanded {
                    guard let habit = habit else {
                        selectedDate =
                            Calendar.current.date(byAdding: .month, value: addedValue, to: selectedDate) ?? Date()
                        return
                    }
                    if habit.cycleType == HabitCycleType.weekly {
                        selectedDate = selectedDate.monthShift(contains: habit.dayOfWeek, isAdd: isAdd)
                        return
                    } else {
                        selectedDate =
                            Calendar.current.date(byAdding: .month, value: addedValue, to: selectedDate) ?? Date()
                        return
                    }
                } else {
                    selectedDate =
                        Calendar.current.date(byAdding: .weekOfMonth, value: addedValue, to: selectedDate) ?? Date()
                    return
                }
            }
        }) {
            Image(systemName: isAdd ? "chevron.right" : "chevron.left")
                .font(.system(size: 20))
                .frame(width: 30, height: 30)
                .foregroundColor(ThemeColor.mainColor(colorScheme))
        }
        .padding(5)
    }
}

/*
 struct CustomCalendar_Previews: PreviewProvider {
 static var previews: some View {
 CalendarRow(selectedDate: .constant(Date()), habit: , isExpanded: true)
 }
 }
 */
