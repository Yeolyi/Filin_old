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
    let date: Date
    let isUnderline: Bool
    @Binding var selectedDate: Date
    
    var body: some View {
        Button(action: {
            selectedDate = date
        }) {
            CircleProgress(progress: progress, color: color, num: Date().dictKey == date.dictKey ? "✓" : String(date.day), isUnderBar: isUnderline, highlighted: date.dictKey == selectedDate.dictKey)
                .frame(width: 40, height: 40)
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
