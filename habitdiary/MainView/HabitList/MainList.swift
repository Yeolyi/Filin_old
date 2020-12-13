//
//  MainView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct MainList: View {
    
    @FetchRequest(entity: HabitInfo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \HabitInfo.userOrder, ascending: true)])
    var habitInfos: FetchedResults<HabitInfo>
    @ObservedObject var listOrderManager = ListOrderManager()
    @EnvironmentObject var sharedViewData: SharedViewData
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        ScrollView {
            SearchBar()
            Text("목록")
                .sectionText()
            ForEach(listOrderManager.habitOrder, id: \.self) { habitId in
                MainRow(habit: habitInfos.first(where: {$0.id==habitId}) ?? HabitInfo(context: managedObjectContext))
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
