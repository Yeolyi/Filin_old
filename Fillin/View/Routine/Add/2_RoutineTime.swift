//
//  2_RoutineTime.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct RoutineTime: View {
    
    @Binding var routineTime: Date
    
    var body: some View {
        HabitAddBadgeView(title: "Add routine".localized, imageName: "clock.arrow.2.circlepath") {
            Text("Time".localized)
                .sectionText()
            DatePicker("Select routine time", selection: $routineTime, displayedComponents: .hourAndMinute)
        }
    }
}

struct RoutineTime_Previews: PreviewProvider {
    static var previews: some View {
        RoutineTime(routineTime: .constant(Date()))
    }
}
