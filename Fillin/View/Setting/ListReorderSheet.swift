//
//  ListReorder.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct ListReorderSheet: View {
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var displayManager: DisplayManager
    var habitList: [Habit] {
        displayManager.habitOrder.map { orderInfo in
            habitInfos.first(where: { habitInfo in
                orderInfo == habitInfo.id
            }) ?? Habit(context: managedObjectContext)
        }
    }
    var body: some View {
        VStack {
            ReorderableList(value: displayManager.habitOrder, save: { newList in
                displayManager.habitOrder = newList
            }, view: { id in
                Text(habitInfos.first(where: {$0.id == id})?.name ?? "")
                    .rowHeadline()
            })
            Spacer()
        }
        .navigationBarTitle(Text("Change list order".localized))
    }
    func move(from source: IndexSet, to destination: Int) {
        displayManager.habitOrder.move(fromOffsets: source, toOffset: destination)
    }
}

struct ListReorder_Previews: PreviewProvider {
    static var previews: some View {
        ListReorderSheet()
    }
}
