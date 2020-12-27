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
                    ZStack {
                        if dayOfTheWeek.contains(dayOfTheWeekInt) {
                            Circle()
                                .foregroundColor(.clear)
                                .overlay(
                                    Circle()
                                        .foregroundColor(ThemeColor.mainColor(colorScheme))
                                )
                        }
                        Text(Date.dayOfTheWeekShortStr(dayOfTheWeekInt))
                            .foregroundColor(dayOfTheWeek.contains(dayOfTheWeekInt) ? .white : .black)
                    }
                    .frame(width: 40, height: 40)
                    .zIndex(0)
                }
            }
        }
        .padding([.leading, .trailing], 10)
    }
}
/*
 struct DayOfWeekSelector_Previews: PreviewProvider {
 static var previews: some View {
 DayOfWeekSelector()
 }
 }
 */
