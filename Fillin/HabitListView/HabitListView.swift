//
//  ContentView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct HabitListView: View {
    @State var showAddModal = false
    @State var editMode = false
    @EnvironmentObject var sharedViewData: AppSetting
    @EnvironmentObject var listOrderManager: DisplayManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>

    var body: some View {
        NavigationView {
            Group {
                if editMode {
                    ListReorder()
                } else {
                    MainList()
                }
            }
            .navigationBarTitle(Date().localizedMonthDay)
            .navigationBarItems(
                leading: listReorderButton,
                trailing: habitPlusButton
            )
        }
        .sheet(isPresented: $showAddModal) {
            AddHabit()
                .environment(\.managedObjectContext, managedObjectContext)
                .environmentObject(listOrderManager)
                .environmentObject(sharedViewData)
        }
        .zIndex(0)
        .onAppear {
            if sharedViewData.isFirstRun && habitInfos.isEmpty {
                showAddModal = true
            }
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    var listReorderButton: some View {
        HStack {
            Button(action: {
                self.editMode.toggle()
            }) {
                    if editMode {
                        Text("Done".localized)
                    } else {
                        Text("Edit".localized)
                    }
            }
        }
    }
    var habitPlusButton: some View {
        Button(action: {
            if !editMode {
                self.showAddModal = true
            }
        }) {
            Image(systemName: "plus")
                .font(.system(size: 25))
        }
        .if(editMode) {
            $0.hidden()
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
