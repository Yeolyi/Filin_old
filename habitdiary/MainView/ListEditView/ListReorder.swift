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
        sortDescriptors: [NSSortDescriptor(keyPath: \HabitInfo.userOrder, ascending: true)]
    )
    var habitInfos: FetchedResults<HabitInfo>
    @EnvironmentObject var listOrderManager: ListOrderManager
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        List {
            ForEach(listOrderManager.habitOrder, id: \.self) { id in
                Text((habitInfos.first(where: {$0.id==id}) ?? HabitInfo(context: managedObjectContext)).name)
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

extension List {
  @ViewBuilder
  func insetGroupedListStyle() -> some View {
    if #available(iOS 14.0, *) {
      self
        .listStyle(InsetGroupedListStyle())
    } else {
      self
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
  }
}
