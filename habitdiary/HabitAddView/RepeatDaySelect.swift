//
//  RepeatDaySelect.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct RepeatDaySelect: View {
    
    @Binding var dayOfTheWeek: [Int]
    
    var body: some View {
        List {
            ForEach(1..<8) { dayOfTheWeekInt in
                HStack {
                    Text(Date.dayOfTheWeekStr(dayOfTheWeekInt) + "요일")
                    Spacer()
                    if dayOfTheWeek.contains(dayOfTheWeekInt) {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if dayOfTheWeek.contains(dayOfTheWeekInt) {
                        dayOfTheWeek.remove(at: dayOfTheWeek.firstIndex(of: dayOfTheWeekInt)!)
                    } else {
                        dayOfTheWeek.append(dayOfTheWeekInt)
                    }
                    dayOfTheWeek = dayOfTheWeek.sorted(by: <)
                }
            }
        }
        .navigationBarTitle("반복")
    }
}

struct RepeatDaySelect_Previews: PreviewProvider {
    static var previews: some View {
        RepeatDaySelect(dayOfTheWeek: .constant([1,3]))
    }
}
