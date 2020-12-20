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
    let dateList: [Date]
    let accentColor: Color
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var habit: HabitInfo
    @Binding var selectedDate: Date
    var body: some View {
        HStack {
            ForEach(dateList, id: \.self) { date in
                if isButtonActive(at: date) {
                    Button(action: {selectedDate = date}) {
                        CircleProgress(
                            progress: percentAchieved(at: date),
                            accentColor: (selectedDate.month == date.month) ?
                                accentColor : ThemeColor.subColor(colorScheme)
                        ) {
                            Text(Date().dictKey == date.dictKey ? "✓" : String(date.day))
                                .foregroundColor(textColor(at: date))
                        }
                        .frame(width: 40, height: 40)
                    }
                } else {
                    CircleProgress(progress: 0, accentColor: Color.gray.opacity(0.1)) {
                        Text(Date().dictKey == date.dictKey ? "✓" : String(date.day))
                            .foregroundColor(ThemeColor.subColor(colorScheme))
                    }
                    .frame(width: 40, height: 40)
                }
            }
        }
    }
    init(week: Int, isExpanded: Bool, habit: HabitInfo, selectedDate: Binding<Date>) {
        self.week = week
        self.isExpanded = isExpanded
        self.habit = habit
        self._selectedDate = selectedDate
        accentColor = Color(hex: habit.color)
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
    func percentAchieved(at date: Date) -> Double {
        Double((habit.achieve[date.dictKey] ?? 0))/Double(habit.targetAmount)
    }
    func isButtonActive(at date: Date) -> Bool {
        habit.habitType == HabitType.daily.rawValue || habit.targetDays?.contains(Int16(date.dayOfTheWeek)) == true
    }
    func textColor(at date: Date) -> Color {
        if selectedDate.month != date.month {
            return ThemeColor.subColor(colorScheme)
        }
        return date.dictKey == selectedDate.dictKey ? accentColor : ThemeColor.mainColor(colorScheme)
    }
}
