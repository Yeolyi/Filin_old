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
    @EnvironmentObject var sharedViewData: SharedViewData
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        if #available(iOS 14.0, *) {
            component
                .listStyle(InsetGroupedListStyle())
        } else {
            component
        }
    }
    
    var component: some View {
        ScrollView {
            SearchBar()
            Text("목록")
                .sectionText()
            ForEach(habitInfos, id: \.self) { habit in
                MainRow(habit: habit)
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
