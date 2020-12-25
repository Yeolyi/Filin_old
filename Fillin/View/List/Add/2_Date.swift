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
        HabitAddBadgeView(title: "Cycle setting".localized, imageName: "calendar") {
            Text("Cycle".localized)
                .sectionText()
            CheckPicker(options: [HabitCycleType.daily, HabitCycleType.weekly], selected: $habitType)
                .padding(8)
                .padding([.leading, .trailing], 10)
            if habitType == .weekly {
                DayOfWeekSelector(dayOfTheWeek: $dayOfTheWeek)
            }
        }
    }
}

struct Test2_Previews: PreviewProvider {
    static var previews: some View {
        DateSection(habitType: .constant(.weekly), dayOfTheWeek: .constant([]))
    }
}
