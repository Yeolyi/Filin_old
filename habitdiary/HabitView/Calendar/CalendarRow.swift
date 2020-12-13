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
    let isExpanded: Bool
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
    
    init(selectedDate: Binding<Date>, habit: HabitInfo, isExpanded: Bool) {
        self._selectedDate = selectedDate
        self.habit = habit
        self.isExpanded = isExpanded
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Spacer()
                    if isExpanded {
                        Text("\(String(selectedDate.year))년 \(selectedDate.month)월")
                            .font(.system(size: 20, weight: .bold))
                    } else {
                        Text("\(selectedDate.month)월 \(selectedDate.day)일")
                            .font(.system(size: 20, weight: .bold))
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
                    }
                    .padding(5)
                }
            }
            .padding(.bottom, 15)
            HStack {
                ForEach(dayOfWeekStr, id: \.self) { str in
                    Text(str)
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(width: 40)
                }
            }
            .padding(.bottom, 5)
            if isExpanded {
                ForEach(1..<lineNum+1, id: \.self) { week in
                    CustomCalendarWeek(week: week, isExpanded: true, habit: habit, selectedDate: $selectedDate)
                        .padding(.bottom, 10)
                }
            } else {
                CustomCalendarWeek(week: selectedDate.weekNum, isExpanded: false, habit: habit, selectedDate: $selectedDate)
                    .padding(.bottom, 10)
            }
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
