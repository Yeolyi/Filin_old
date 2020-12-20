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
        entity: HabitInfo.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<HabitInfo>
    var body: some View {
        HabitAddBadgeView(
            title: "\(sharedViewData.isFirstRun && habitInfos.isEmpty ? "첫번째" : "새로운") 목표 만들기",
            imageName: "text.badge.checkmark"
        ) {
            Text("제목")
                .sectionText()
            TextFieldWithEndButton("물 마시기", text: $name)
        }
    }
}

struct Test1_Previews: PreviewProvider {
    static var previews: some View {
        NameSection(name: .constant(""))
    }
}
