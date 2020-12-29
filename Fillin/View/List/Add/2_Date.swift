//
//  Test2.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct DateSection: View {
    @Binding var habitType: HabitCycleType
    @Binding var dayOfTheWeek: [Int]
    var body: some View {
        HabitAddBadgeView(title: "Repeat".localized, imageName: "calendar") {
            Text("Choose the day of the week to proceed with the goal.".localized)
                .rowHeadline()
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
            DayOfWeekSelector(dayOfTheWeek: $dayOfTheWeek)
        }
    }
}

struct Test2_Previews: PreviewProvider {
    static var previews: some View {
        DateSection(habitType: .constant(.weekly), dayOfTheWeek: .constant([]))
    }
}
