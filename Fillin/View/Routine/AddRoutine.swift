//
//  AddRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

struct AddRoutine: View {
    
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
    
    @State var name = ""
    @State var tempIDList: [UUID] = []
    
    var body: some View {
        VStack {
            InlineNavigationBar(
                title: "Add routine".localized,
                button1: { EmptyView() },
                button2: {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save".localized)
                            .headerButton()
                    }
                }
            )
            Spacer()
            ScrollView {
                ForEach(habitList) { habit in
                    HStack {
                        Text(habit.name)
                        Spacer()
                    }
                    .rowBackground()
                }
            }
        }
    }
}

struct AddRoutine_Previews: PreviewProvider {
    static var previews: some View {
        AddRoutine()
    }
}
