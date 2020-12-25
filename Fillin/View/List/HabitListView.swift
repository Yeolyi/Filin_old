//
//  ContentView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct HabitListView: View {
    @State var isAddSheet = false
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var displayManager: DisplayManager
    @EnvironmentObject var appSetting: AppSetting
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    
    var body: some View {
        NavigationView {
            HabitList()
                .navigationBarTitle(Date().localizedMonthDay)
                .navigationBarItems(
                    trailing: habitPlusButton
                )
                .sheet(isPresented: $isAddSheet) {
                    AddHabit()
                        .environment(\.managedObjectContext, managedObjectContext)
                        .environmentObject(displayManager)
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
    var habitPlusButton: some View {
        Button(action: {
            self.isAddSheet = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 25))
        }
    }
}

/*
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 ContentView()
 .environment(\.managedObjectContext, context)
 .environmentObject(AppSetting())
 .previewDevice(.init(stringLiteral: "iPhone 12 mini"))
 }
 }
 */
