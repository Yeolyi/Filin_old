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
        List {
            ForEach(habitList, id: \.self) { habitInfo in
                Text(habitInfo.name)
            }
            .onMove(perform: move)
        }
        .insetGroupedListStyle()
        .environment(\.editMode, .constant(EditMode.active))
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
