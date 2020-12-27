//
//  1_Name.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

struct RoutineSetList: View {
    
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [])
    var habitInfos: FetchedResults<Habit>
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var displayManager: DisplayManager
    var habitList: [Habit] {
        displayManager.habitOrder.compactMap { orderInfo in
            habitInfos.first(where: { habitInfo in
                orderInfo == habitInfo.id
            })
        }
    }
    @ObservedObject var listData: ListData<UUID>
    
    init(listData: ListData<UUID>) {
        self.listData = listData
    }
    
    var body: some View {
        VStack {
            Text("Added".localized)
                .sectionText()
            ReorderableList(listData: listData, maxHeight: 250, view: { id in
                HStack {
                    Image(systemName: "minus.circle")
                        .font(.system(size: 20))
                        .mainColor()
                        .contentShape(Rectangle())
                        .padding(.trailing, 5)
                        .onTapGesture {
                            listData.delete(id: id)
                        }
                    Text(habitList.first(where: {$0.id == listData.internalIDToValue(id)})?.name ?? "Test")
                        .rowHeadline()
                }
            })
            .rowBackground()
            
            Text("List".localized)
                .sectionText()
            ScrollView {
                ForEach(habitList) { habit in
                    HStack {
                        Text(habit.name)
                            .rowHeadline()
                        Spacer()
                        Image(systemName: "plus.circle")
                            .font(.system(size: 20))
                            .mainColor()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                guard let id = habit.id else {
                                    return
                                }
                                listData.add(value: id)
                            }
                    }
                    .padding(8)
                    .padding([.leading, .trailing], 10)
                }
            }
        }
        .padding(.top, 10)
    }
}
