//
//  ContentView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct HabitListView: View {
    @State var isAddSheet = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var displayManager: DisplayManager
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    
    var body: some View {
        NavigationView {
            Group {
                if habitInfos.isEmpty {
                    ScrollView {
                        MainRow(habit: sampleHabit(name: "A ten-minute walk".localized, dayOfWeek: [1, 3, 5, 7], seconds: 600, count: 3), showAdd: true)
                            .opacity(0.5)
                            .disabled(true)
                        MainRow(habit: sampleHabit(name: "Stretching".localized), showAdd: true)
                            .opacity(0.5)
                            .disabled(true)
                        Text("Set goals and execute them.".localized)
                            .rowHeadline()
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        ListEmptyButton(action: { isAddSheet = true }, str: "Add new goal".localized)
                    }
                    .padding(.top, 1)
                } else {
                    HabitList()
                }
            }
                .navigationBarTitle(Date().localizedMonthDay)
                .navigationBarItems(
                    trailing: habitPlusButton
                )
                .sheet(isPresented: $isAddSheet) {
                    AddHabit()
                        .environment(\.managedObjectContext, managedObjectContext)
                        .environmentObject(displayManager)
                        .environmentObject(appSetting)
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
