//
//  ContentView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct ContentView: View {
    
    @State var showAddModal = false
    @State var editMode = false
    @EnvironmentObject var sharedViewData: SharedViewData
    @EnvironmentObject var listOrderManager: ListOrderManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: HabitInfo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \HabitInfo.userOrder, ascending: true)]
    )
    var habitInfos: FetchedResults<HabitInfo>
    
    var body: some View {
        NavigationView {
            Group {
                if editMode {
                    ListReorder()
                } else {
                    MainList()
                }
            }
            .navigationBarTitle("\(Date().month)월 \(Date().day)일 목표")
            .navigationBarItems(
                leading: listReorderButton,
                trailing: habitPlusButton
            )
        }
        .sheet(isPresented: $showAddModal) {
            AddHabit()
                .environment(\.managedObjectContext, managedObjectContext)
                .environmentObject(listOrderManager)
        }
    }
    
    var listReorderButton: some View {
        HStack {
            Button(action: {
                self.editMode.toggle()
            }) {
                if editMode {
                    Text("완료")
                } else {
                    Text("편집")
                }
            }
        }
    }
    
    var habitPlusButton: some View {
        Button(action: {
            self.showAddModal = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 25, weight: .light))
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        ContentView()
            .environment(\.managedObjectContext, context)
            .environmentObject(SharedViewData())
            .previewDevice(.init(stringLiteral: "iPhone 12 mini"))
    }
}
