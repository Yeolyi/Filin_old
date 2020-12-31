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
        HStack(spacing: 8) {
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
                                .frame(width: 40, height: 40)
                        }
                        Text(Date.dayOfTheWeekShortStr(dayOfTheWeekInt))
                            .foregroundColor(dayOfTheWeek.contains(dayOfTheWeekInt) ? .white : .black)
                            .bodyText()
                    }
                    .frame(width: 40, height: 40)
                    .zIndex(0)
                }
            }
        }
        .padding(.vertical, 3)
    }
}
/*
 struct DayOfWeekSelector_Previews: PreviewProvider {
 static var previews: some View {
 DayOfWeekSelector()
 }
 }
 */
