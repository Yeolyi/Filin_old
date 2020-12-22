//
//  MainView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct MainList: View {
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [])
    var habitInfos: FetchedResults<Habit>
    @EnvironmentObject var sharedViewData: AppSetting
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    @State var searchWord = ""
    var habitList: [Habit] {
        DisplayManager().habitOrder.map { orderInfo in
            habitInfos.first(where: { habitInfo in
                orderInfo == habitInfo.id
            }) ?? Habit(context: managedObjectContext)
        }
    }
    var isTodayEmpty: Bool { habitList.filter { $0.isTodayTodo }.isEmpty }
    var isGeneralEmpty: Bool { habitInfos.count - habitList.filter { $0.isTodayTodo }.count == 0 }
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Today".localized)
                    .sectionText()
                if !isTodayEmpty {
                    ForEach(habitList.filter {$0.isTodayTodo}, id: \.self) { habitInfo in
                        MainRow(habit: habitInfo, showAdd: true, showCheck: habitInfo.isComplete(at: Date()))
                    }
                } else {
                    HStack {
                        Spacer()
                        Text("Empty".localized)
                            .foregroundColor(ThemeColor.subColor(colorScheme))
                        Spacer()
                    }
                    .rowBackground()
                }
                if !isGeneralEmpty {
                    Text("Goals".localized)
                        .sectionText()
                }
                ForEach(habitList.filter {!$0.isTodayTodo}, id: \.self) { habitInfo in
                    MainRow(habit: habitInfo, showAdd: false, showCheck: false)
                }
            }
        }
        .padding(.top, 1)
    }
}

struct MainList_Previews: PreviewProvider {
    static var previews: some View {
        MainList()
    }
}
