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
    @State var currentDate = Date()
    let isExpanded: Bool
    var lineNum: Int {
        let date = currentDate
        let calendar = Calendar.current
        let weekRange = calendar.range(
            of: .weekOfMonth,
            in: .month,
            for: date
        )
        return weekRange?.count ?? 0
    }
    var currentWeekNum: Int {
        let calendar = Calendar.current
        return calendar.component(.weekOfMonth, from: currentDate) - 1
    }
    let dayOfWeekStr = ["일", "월", "화", "수", "목", "금", "토"]
    
    init(selectedDate: Binding<Date>, habit: HabitInfo, isExpanded: Bool) {
        self._selectedDate = selectedDate
        self.habit = habit
        self.isExpanded = isExpanded
        self.currentDate = Date()
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    Text("\(String(currentDate.year))년 \(currentDate.month)월")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: monthMinus) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                    }
                    .padding(5)
                    Button(action: monthPlus) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                    }
                    .padding(5)
                }
            }
            HStack {
                ForEach(dayOfWeekStr, id: \.self) { str in
                    Text(str)
                        .font(.headline)
                        .frame(width: 40, height: 40)
                }
            }
            if isExpanded {
                ForEach(0..<lineNum, id: \.self) { week in
                    CustomCalendarWeek(week: week, currentDate: currentDate, habit: habit, selectedDate: $selectedDate)
                }
            } else {
                CustomCalendarWeek(week: currentWeekNum, currentDate: currentDate, habit: habit, selectedDate: $selectedDate)
            }
        }
    }
    
    func monthMinus() {
        let calendar = Calendar.current
        guard currentDate.month-1 >= 1 else {
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
            if dateComponents.year != nil {
                dateComponents.year = dateComponents.year! - 1
                dateComponents.month = 12
            }
            currentDate =  calendar.date(from: dateComponents) ?? Date()
            return
        }
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        if dateComponents.month != nil {
            dateComponents.month = dateComponents.month! - 1
        }
        currentDate = calendar.date(from: dateComponents) ?? Date()
    }
    
    func monthPlus() {
        let calendar = Calendar.current
        guard currentDate.month+1 <= 12 else {
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
            if dateComponents.year != nil {
                dateComponents.year = dateComponents.year! + 1
                dateComponents.month = 1
            }
            currentDate =  calendar.date(from: dateComponents) ?? Date()
            return
        }
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        if dateComponents.month != nil {
            dateComponents.month = dateComponents.month! + 1
        }
        currentDate =  calendar.date(from: dateComponents) ?? Date()
    }
}


/*
 struct CustomCalendar_Previews: PreviewProvider {
 static var previews: some View {
 CalendarRow(selectedDate: .constant(Date()), habit: , isExpanded: true)
 }
 }
 */
