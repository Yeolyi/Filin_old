//
//  Test1.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct NameSection: View {
    @Binding var name: String
    @EnvironmentObject var sharedViewData: AppSetting
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    var body: some View {
        HabitAddBadgeView(
            title: sharedViewData.isFirstRun && habitInfos.isEmpty ? "Make first goal".localized : "Make new goal".localized,
            imageName: "text.badge.checkmark"
        ) {
            Text("Name".localized)
                .sectionText()
            TextFieldWithEndButton("Drink water".localized, text: $name)
        }
    }
}

struct Test1_Previews: PreviewProvider {
    static var previews: some View {
        NameSection(name: .constant(""))
    }
}
