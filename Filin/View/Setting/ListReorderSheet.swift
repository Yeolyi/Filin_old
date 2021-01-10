//
//  ListReorder.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct ListReorderSheet: View {
   
    @State var listData = ListData<UUID>(values: [], save: {_ in})
    
    var body: some View {
        NavigationView {
            VStack {
                ReorderableList(
                    listData: listData,
                    view: { id in
                        Text(HabitContextManager.shared.contents.first(where: {$0.id == listData.internalIDToValue(id)})?.name ?? "")
                            .bodyText()
                    })
                    .padding(8)
                    .padding([.leading, .trailing], 10)
                Spacer()
            }
            .navigationBarTitle(Text("Change List Order".localized))
        }
        .onAppear {
            self.listData = ListData(values: HabitContextManager.shared.habitOrder, save: { newList in
                HabitContextManager.shared.habitOrder = newList
            })
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        HabitContextManager.shared.habitOrder.move(fromOffsets: source, toOffset: destination)
    }
    
}

struct ListReorder_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview.shared
        return ListReorderSheet()
            .environmentObject(AppSetting())
    }
}
