//
//  ContentView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct HabitList: View {
    @State var isAddSheet = false
    
    var body: some View {
        NavigationView {
            Group {
                if habitInfos.isEmpty {
                    ListPreview(isAddSheet: $isAddSheet)
                } else {
                    HabitScrollView()
                }
            }
            .navigationBarTitle(Date().localizedMonthDay)
            .navigationBarItems(
                trailing:
                    HeaderButton("plus") {
                        self.isAddSheet = true
                    }
            )
            .sheet(isPresented: $isAddSheet) {
                AddHabit()
                    .environment(\.managedObjectContext, managedObjectContext)
                    .environmentObject(displayManager)
                    .environmentObject(appSetting)
                    .environmentObject(incrementPerTap)
            }
        }
        .onAppear {
            if appSetting.isFirstRun && habitInfos.isEmpty {
                isAddSheet = true
            }
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var displayManager: DisplayManager
    @EnvironmentObject var incrementPerTap: IncrementPerTap
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
}

struct HabitList_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview()
        return HabitList()
            .environment(\.managedObjectContext, coreDataPreview.context)
            .environmentObject(AppSetting())
            .environmentObject(coreDataPreview.displayManager)
            //.previewDevice(.init(stringLiteral: "iPhone 12 mini"))
    }
}
