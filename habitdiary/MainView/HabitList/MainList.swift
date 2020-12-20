//
//  MainView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct MainList: View {
    @FetchRequest(entity: HabitInfo.entity(), sortDescriptors: [])
    var habitInfos: FetchedResults<HabitInfo>
    @EnvironmentObject var sharedViewData: AppSetting
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    @State var searchWord = ""
    var habitList: [HabitInfo] {
        ListOrderManager().habitOrder.map { orderInfo in
            habitInfos.first(where: { habitInfo in
                orderInfo.elementId == habitInfo.id
            }) ?? HabitInfo(context: managedObjectContext)
        }
    }
    var isTodayEmpty: Bool { habitList.filter { $0.isTodayTodo }.isEmpty }
    var isGeneralEmpty: Bool { habitInfos.count - habitList.filter { $0.isTodayTodo }.count == 0 }
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("오늘")
                    .sectionText()
                if !isTodayEmpty {
                    ForEach(habitList.filter {$0.isTodayTodo}, id: \.self) { habitInfo in
                        MainRow(habit: habitInfo, showAdd: true, showCheck: habitInfo.isComplete(at: Date()))
                    }
                } else {
                    HStack {
                        Spacer()
                        Text("비어있음")
                            .foregroundColor(ThemeColor.subColor(colorScheme))
                        Spacer()
                    }
                    .rowBackground()
                }
                if !isGeneralEmpty {
                    Text("전체")
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
