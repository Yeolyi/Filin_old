//
//  MainView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct HabitScrollView: View {

    @State var searchWord = ""
    var habitDisplayList: [Habit] {
        displayManager.habitOrder.compactMap { orderInfo in
            habitList.first(where: { habitInfo in
                orderInfo == habitInfo.id
            })
        }
    }
    var isTodayEmpty: Bool {
        habitDisplayList.filter({$0.isTodayTodo}).isEmpty
    }
    var isGeneralEmpty: Bool {
        (habitList.count - habitDisplayList.filter({$0.isTodayTodo}).count) == 0
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Today".localized)
                    .sectionText()
                if !isTodayEmpty {
                    ForEach(habitDisplayList.filter {$0.isTodayTodo}, id: \.self) { habitInfo in
                        if habitInfo.isFault {
                            EmptyView()
                        } else {
                            HabitRow(habit: habitInfo, showAdd: true)
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        Text("Empty".localized)
                            .subColor()
                        Spacer()
                    }
                    .rowBackground()
                }
                Text("Others".localized)
                    .sectionText()
                if !isGeneralEmpty {
                    ForEach(habitDisplayList.filter {!$0.isTodayTodo}, id: \.self) { habitInfo in
                        if habitInfo.isFault {
                            EmptyView()
                        } else {
                            HabitRow(habit: habitInfo, showAdd: false)
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        Text("Empty".localized)
                            .subColor()
                        Spacer()
                    }
                    .rowBackground()
                }
                
            }
        }
        .padding(.top, 1)
    }
    
    @EnvironmentObject var displayManager: DisplayManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [])
    var habitList: FetchedResults<Habit>
    
}

struct MainList_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview()
        return HabitScrollView()
            .environment(\.managedObjectContext, coreDataPreview.context)
            .environmentObject(AppSetting())
            .environmentObject(coreDataPreview.displayManager)
    }
}
