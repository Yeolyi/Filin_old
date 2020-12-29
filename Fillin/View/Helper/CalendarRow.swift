//
//  CalendarRow.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

class CalendarHabitList: ObservableObject {
    @Published var habits: [Habit?] = []
    init(habits: [Habit?]) {
        self.habits = habits
    }
}


struct CalendarRow<Content: View>: View {
    @Binding var selectedDate: Date
    @Binding var isExpanded: Bool
    @Environment(\.colorScheme) var colorScheme
    let content: (_ week: Int, _ isExpanded: Bool) -> Content
    let move: (Bool) -> Date
    init(selectedDate: Binding<Date>, isExpanded: Binding<Bool>,
         move: @escaping (Bool) -> Date, content: @escaping (_ week: Int, _ isExpanded: Bool) -> Content
    ) {
        self._selectedDate = selectedDate
        self._isExpanded = isExpanded
        self.content = content
        self.move = move
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
                    content(week, true)
                }
            } else {
                content(selectedDate.weekNum, false)
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
            withAnimation {
                selectedDate = move(isAdd)
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
