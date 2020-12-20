//
//  ListReorder.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct ListReorder: View {
    @FetchRequest(
        entity: HabitInfo.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<HabitInfo>
    @EnvironmentObject var listOrderManager: ListOrderManager
    @Environment(\.managedObjectContext) var managedObjectContext
    var habitList: [HabitInfo] {
        ListOrderManager().habitOrder.map { orderInfo in
            habitInfos.first(where: { habitInfo in
                orderInfo.elementId == habitInfo.id
            }) ?? HabitInfo(context: managedObjectContext)
        }
    }
    var body: some View {
        List {
            ForEach(habitList, id: \.self) { habitInfo in
                Text(habitInfo.name)
            }
            .onMove(perform: move)
            .onDelete(perform: remove)
        }
        .insetGroupedListStyle()
        .environment(\.editMode, .constant(EditMode.active))
    }
    func move(from source: IndexSet, to destination: Int) {
        listOrderManager.habitOrder.move(fromOffsets: source, toOffset: destination)
    }
    func remove(at offsets: IndexSet) {
        listOrderManager.habitOrder.remove(atOffsets: offsets)
    }
}

struct ListReorder_Previews: PreviewProvider {
    static var previews: some View {
        ListReorder()
    }
}
