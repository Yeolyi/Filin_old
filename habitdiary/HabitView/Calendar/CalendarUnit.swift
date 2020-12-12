//
//  CalendarUnit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct CalendarUnit: View {
    
    let color: Color
    let progress: Double
    let date: Date?
    let isUnderline: Bool
    let currentDate: Date
    @Binding var selectedDate: Date
    
    var body: some View {
        Button(action: {
            if let day = date?.day {
                let calendar = Calendar.current
                var dateComponents  = calendar.dateComponents([.year, .month], from: currentDate)
                dateComponents.day = day
                selectedDate = calendar.date(from: dateComponents) ?? selectedDate
            }
        }) {
            if date != nil {
                CircleProgress(progress: progress, color: color, num: date?.day, isUnderBar: isUnderline, highlighted: date!.dictKey == selectedDate.dictKey)
                    .frame(width: 40, height: 40)
            } else {
                CircleProgress(progress: 0, color: .gray, num: nil, isUnderBar: isUnderline, highlighted: false)
                    .frame(width: 40, height: 40)
            }
        }
    }
    
}

/*
struct CalendarUnit_Previews: PreviewProvider {
    static var previews: some View {
        CalendarUnit(num: nil, selectedDate: .constant(Date()))
    }
}
*/
