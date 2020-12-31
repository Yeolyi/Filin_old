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
    @State var listData = ListData<UUID>(values: [], save: {_ in})
    var body: some View {
        NavigationView {
            VStack {
                ReorderableList(
                    listData: listData,
                    view: { id in
                        Text(habitInfos.first(where: {$0.id == listData.internalIDToValue(id)})?.name ?? "")
                            .headline()
                    })
                    .padding(8)
                    .padding([.leading, .trailing], 10)
                Spacer()
            }
            .navigationBarTitle(Text("Change List Order".localized))
        }
        .onAppear {
            self.listData = ListData(values: displayManager.habitOrder, save: { newList in
                displayManager.habitOrder = newList
            })
        }
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
