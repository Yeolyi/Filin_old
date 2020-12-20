//
//  DayOfWeekSelector.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct DayOfWeekSelector: View {
    @Binding var dayOfTheWeek: [Int]
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            ForEach(1..<8) { dayOfTheWeekInt in
                Button(action: {
                    if dayOfTheWeek.contains(dayOfTheWeekInt) {
                        dayOfTheWeek.remove(at: dayOfTheWeek.firstIndex(of: dayOfTheWeekInt)!)
                    } else {
                        dayOfTheWeek.append(dayOfTheWeekInt)
                    }
                }) {
                    CircleProgress(progress: 0, accentColor: ThemeColor.mainColor(colorScheme)) {
                        Text(Date.dayOfTheWeekStr(dayOfTheWeekInt))
                            .foregroundColor(
                                dayOfTheWeek.contains(dayOfTheWeekInt) ?
                                    ThemeColor.mainColor(colorScheme) : ThemeColor.subColor(colorScheme)
                            )
                    }
                    .frame(width: 40, height: 40)
                    .zIndex(0)
                }
            }
        }
        .rowBackground()
    }
}
/*
struct DayOfWeekSelector_Previews: PreviewProvider {
    static var previews: some View {
        DayOfWeekSelector()
    }
}
*/
