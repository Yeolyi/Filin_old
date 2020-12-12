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
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        List {
            ForEach(habitInfos) { habitInfo in
                Text(habitInfo.name )
            }
            .onMove(perform: move)
            .onDelete(perform: remove)
        }
        .insetGroupedListStyle()
        .environment(\.editMode, .constant(EditMode.active))
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var revisedItems: [HabitInfo] = habitInfos.map{$0}
        revisedItems.move(fromOffsets: source, toOffset: destination )
        // update the userOrder attribute in revisedItems to
        // persist the new order. This is done in reverse order
        // to minimize changes to the indices.
        for reverseIndex in stride(from: revisedItems.count - 1, through: 0, by: -1) {
            revisedItems[reverseIndex].userOrder = Int16(reverseIndex)
        }
        CoreDataManager.save(managedObjectContext)
    }
    
    func remove(at offsets: IndexSet) {
        for index in offsets {
            let habit = habitInfos[index]
            managedObjectContext.delete(habit)
        }
        CoreDataManager.save(managedObjectContext)
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
