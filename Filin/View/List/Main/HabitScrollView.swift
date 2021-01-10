//
//  MainView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct HabitScrollView: View {
    
    @EnvironmentObject var habitManager: HabitContextManager
    @State var searchWord = ""
    
    var isTodayEmpty: Bool {
        habitManager.contents.filter(\.isTodayTodo).isEmpty
    }
    var isGeneralEmpty: Bool {
        (habitManager.contents.count - habitManager.contents.filter(\.isTodayTodo).count) == 0
    }
    
    var emptyIndicatingRow: some View {
        HStack {
            Spacer()
            Text("Empty".localized)
                .subColor()
            Spacer()
        }
        .rowBackground()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Today".localized)
                    .sectionText()
                if !isTodayEmpty {
                    ForEach(habitManager.ordered.filter(\.isTodayTodo)) { habitInfo in
                        HabitRow(habit: habitInfo, showAdd: true)
                            .environmentObject(habitInfo)
                    }
                } else {
                    emptyIndicatingRow
                }
                Text("Others".localized)
                    .sectionText()
                if !isGeneralEmpty {
                    ForEach(habitManager.ordered.filter({!$0.isTodayTodo}), id: \.self) { habitInfo in
                        HabitRow(habit: habitInfo, showAdd: false)
                    }
                } else {
                   emptyIndicatingRow
                }
                
            }
        }
        .padding(.top, 1)
    }
}

struct MainList_Previews: PreviewProvider {
    static var previews: some View {
        _ = CoreDataPreview.shared
        return
            NavigationView {
                HabitScrollView()
                .environmentObject(AppSetting())
                    .navigationBarTitle(Text("Test"))
            }
    }
}
