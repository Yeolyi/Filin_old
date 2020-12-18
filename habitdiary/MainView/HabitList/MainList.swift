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
    @EnvironmentObject var listOrderManager: ListOrderManager
    @EnvironmentObject var sharedViewData: SharedViewData
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var searchWord = ""
    
    func showCheck(id: UUID) -> Bool {
        let habit = habitInfos.first(where: {$0.id==id}) ?? HabitInfo(context: managedObjectContext)
        let targetAmount = habit.targetAmount
        let currentAmount = habit.achieve[Date().dictKey] ?? 0
        return targetAmount <= currentAmount
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                    Text("오늘")
                        .sectionText()
                if listOrderManager.habitOrder.filter{($0.dayOfWeek == nil) || (($0.dayOfWeek?.contains(Date().dayOfTheWeek)) == true)}.isEmpty == false {
                    ForEach(listOrderManager.habitOrder, id: \.self) { orderInfo in
                        if ((orderInfo.dayOfWeek == nil) || ((orderInfo.dayOfWeek?.contains(Date().dayOfTheWeek)) == true)) {
                            MainRow(
                                habit: habitInfos.first(where: {$0.id==orderInfo.id}) ?? HabitInfo(context: managedObjectContext),
                                showAdd: true,
                                showCheck: showCheck(id: orderInfo.id)
                            )
                        } else {
                            EmptyView()
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        Text("비어있음")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .rowBackground()
                }
                
                if !listOrderManager.habitOrder.filter{$0.dayOfWeek?.contains(Date().dayOfTheWeek) == false}.isEmpty {
                        Text("전체")
                            .sectionText()
                }
                
                ForEach(listOrderManager.habitOrder, id: \.self) { orderInfo in
                    if ((orderInfo.dayOfWeek?.contains(Date().dayOfTheWeek)) == false) {
                        MainRow(
                            habit: habitInfos.first(where: {$0.id==orderInfo.id}) ?? HabitInfo(context: managedObjectContext),
                            showAdd: false,
                            showCheck: false
                        )
                    } else {
                        EmptyView()
                    }
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
