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
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("Add the desired goal to the routine. Duplicates are also possible.".localized)
                    .bodyText()
                    .padding(.bottom, 5)
                ScrollView {
                    ForEach(habitList) { habit in
                        HStack {
                            Text(habit.name)
                                .bodyText()
                            Spacer()
                            BasicButton("plus") {
                                guard let id = habit.id else {
                                    return
                                }
                                listData.add(value: id)
                            }
                        }
                    }
                }
            }
            .rowBackground()
            .padding(.bottom, 8)
            VStack(spacing: 0) {
                HStack {
                    Text("Routine List".localized)
                        .headline()
                    Spacer()
                }
                ReorderableList(listData: listData, maxHeight: 250, view: { id in
                    HStack {
                        BasicButton("minus") {
                            listData.delete(id: id)
                        }
                        Text(habitList.first(where: {$0.id == listData.internalIDToValue(id)})?.name ?? "Test")
                            .bodyText()
                    }
                })
            }
            .padding(.horizontal, 20)
        }
    }
}
