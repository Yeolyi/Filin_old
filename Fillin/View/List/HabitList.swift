//
//  MainView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct HabitList: View {
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [])
    var habitInfos: FetchedResults<Habit>
    @EnvironmentObject var displayManager: DisplayManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    @State var searchWord = ""
    var habitList: [Habit] {
        displayManager.habitOrder.compactMap { orderInfo in
            habitInfos.first(where: { habitInfo in
                orderInfo == habitInfo.id
            })
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
                        if habitInfo.isFault {
                            EmptyView()
                        } else {
                            MainRow(habit: habitInfo, showAdd: true)
                        }
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
                    if habitInfo.isFault {
                        EmptyView()
                    } else {
                        MainRow(habit: habitInfo, showAdd: false)
                    }
                }
            }
        }
        .padding(.top, 1)
    }
}

struct MainList_Previews: PreviewProvider {
    static var previews: some View {
        HabitList()
    }
}
