//
//  CustomCalendar.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct CalendarRow: View {
    @Binding var selectedDate: Date
    @ObservedObject var habit: HabitInfo
    @State var isExpanded = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Spacer()
                    Group {
                        if isExpanded {
                            Text("\(String(selectedDate.year))년 \(selectedDate.month)월")
                        } else {
                            Text("\(selectedDate.month)월 \(selectedDate.day)일")
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
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { str in
                    Text(str)
                        .rowSubheadline()
                        .foregroundColor(.gray)
                        .frame(width: 40)
                }
            }
            .padding(.bottom, 8)
            if isExpanded {
                ForEach(1..<(selectedDate.weekInMonth ?? 2) + 1, id: \.self) { week in
                    CustomCalendarWeek(week: week, isExpanded: true, habit: habit, selectedDate: $selectedDate)
                        .padding(.bottom, 10)
                }
            } else {
                CustomCalendarWeek(
                    week: selectedDate.weekNum, isExpanded: false, habit: habit, selectedDate: $selectedDate
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
                .foregroundColor(ThemeColor.subColor(colorScheme))
        }
        .padding(5)
    }
    func moveButton(isAdd: Bool) -> some View {
        Button(action: {
            withAnimation {
                if isExpanded {
                    if habit.habitType == HabitType.weekly.rawValue {
                        let calendar = Calendar.current //2025 4/30
                        let currentWeekNum = selectedDate.weekNum //5
                        let nextMonth = isAdd ? calendar.date(byAdding: .month, value: 1, to: selectedDate)!
                        : calendar.date(byAdding: .month, value: -1, to: selectedDate)!
                        let nextMonthWeeknum = nextMonth.weekNum //6
                        var nextMonthStartDay = nextMonth.firstDayOfMonth! // 3/1
                        while nextMonthStartDay.dayOfTheWeek != selectedDate.dayOfTheWeek {
                            nextMonthStartDay = calendar.date(byAdding: .day, value: 1, to: nextMonthStartDay)!
                        }
                        let nextMonthStartWeekNum = nextMonthStartDay.weekNum //1
                        var targetWeekNum = currentWeekNum
                        if nextMonthWeeknum < currentWeekNum {
                            targetWeekNum = nextMonthWeeknum
                        }
                        if currentWeekNum < nextMonthStartWeekNum {
                            selectedDate =
                                calendar.date(byAdding: .weekOfMonth, value: isAdd ? 1 : -1, to: selectedDate)!
                            targetWeekNum = nextMonthStartWeekNum
                        }
                        repeat {
                        selectedDate =
                            Calendar.current.date(byAdding: .weekOfMonth, value: isAdd ? 1 : -1, to: selectedDate)!
                        } while selectedDate.weekNum != targetWeekNum
                    } else {
                        selectedDate =
                            Calendar.current.date(byAdding: .month, value: isAdd ? 1 : -1, to: selectedDate) ?? Date()
                    }
                } else {
                    selectedDate =
                        Calendar.current.date(byAdding: .weekOfMonth, value: isAdd ? 1 : -1, to: selectedDate) ?? Date()
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
