//
//  ListReorder.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct ListReorder: View {
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    @EnvironmentObject var listOrderManager: DisplayManager
    @Environment(\.managedObjectContext) var managedObjectContext
    var habitList: [Habit] {
        DisplayManager().habitOrder.map { orderInfo in
            habitInfos.first(where: { habitInfo in
                orderInfo == habitInfo.id
            }) ?? Habit(context: managedObjectContext)
        }
    }
    var body: some View {
        ReorderableList(value: listOrderManager.habitOrder, save: { newList in
            listOrderManager.habitOrder = newList
        }, view: { id in
            Text(habitInfos.first(where: {$0.id == id})?.name ?? "")
        })
    }
    func move(from source: IndexSet, to destination: Int) {
        listOrderManager.habitOrder.move(fromOffsets: source, toOffset: destination)
    }
}

struct ListReorder_Previews: PreviewProvider {
    static var previews: some View {
        ListReorder()
    }
}
