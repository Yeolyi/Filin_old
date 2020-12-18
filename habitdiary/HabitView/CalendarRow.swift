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
    var lineNum: Int {
        let date = selectedDate
        let calendar = Calendar.current
        let weekRange = calendar.range(
            of: .weekOfMonth,
            in: .month,
            for: date
        )
        return weekRange?.count ?? 0
    }
    let dayOfWeekStr = ["일", "월", "화", "수", "목", "금", "토"]
    let ordinalToStr = [1: "첫", 2:"둘", 3:"셋", 4:"넷", 5:"다섯번"]
    
    init(selectedDate: Binding<Date>, habit: HabitInfo) {
        self._selectedDate = selectedDate
        self.habit = habit
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Spacer()
                    if isExpanded {
                        Text("\(String(selectedDate.year))년 \(selectedDate.month)월")
                            .rowHeadline()
                    } else {
                        Text("\(selectedDate.month)월 \(selectedDate.day)일")
                            .rowHeadline()
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            if isExpanded {
                                selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
                            } else {
                                selectedDate = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: selectedDate) ?? Date()
                            }
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .frame(width: 30, height: 30)
                            .foregroundColor(ThemeColor.mainColor)
                    }
                    .padding(5)
                    Button(action: {
                        withAnimation {
                            if isExpanded {
                                selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
                            } else {
                                selectedDate = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: selectedDate) ?? Date()
                            }
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                            .frame(width: 30, height: 30)
                            .foregroundColor(ThemeColor.mainColor)
                    }
                    .padding(5)
                }
            }
            .padding(.bottom, 15)
            HStack {
                ForEach(dayOfWeekStr, id: \.self) { str in
                    Text(str)
                        .rowSubheadline()
                        .foregroundColor(.gray)
                        .frame(width: 40)
                }
            }
            .padding(.bottom, 8)
            if isExpanded {
                ForEach(1..<lineNum+1, id: \.self) { week in
                    CustomCalendarWeek(week: week, isExpanded: true, habit: habit, selectedDate: $selectedDate)
                        .padding(.bottom, 10)
                }
            } else {
                CustomCalendarWeek(week: selectedDate.weekNum, isExpanded: false, habit: habit, selectedDate: $selectedDate)
                    .padding(.bottom, 10)
            }
            Button(action: {
                withAnimation {
                    self.isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "chevron.compact.up" : "chevron.compact.down")
                    .font(.system(size: 20))
                    .frame(width: 30, height: 30)
                    .foregroundColor(ThemeColor.secondaryColor)
            }
            .padding(5)
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
