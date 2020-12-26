//
//  RoutineDetailVIew.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct RoutineDetailView: View {
    
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [])
    var habitInfos: FetchedResults<Habit>
    @ObservedObject var routine: Routine
    @State var isEditSheet = false
    @EnvironmentObject var displayManager: DisplayManager
    @Environment(\.managedObjectContext) var context
    var habitList: [Habit] {
        routine.list.compactMap { habitID in
            habitInfos.first(where: {$0.id == habitID})
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(habitList, id: \.self) { habit in
                    Text(habit.name)
                }
            }
        }
            .navigationBarTitle(routine.name)
            .navigationBarItems(trailing:
                Button(action: { isEditSheet = true }) {
                    Text("Edit".localized)
                }
            )
            .sheet(isPresented: $isEditSheet) {
                EditRoutine(routine: routine)
                    .environmentObject(displayManager)
                    .environment(\.managedObjectContext, context)
            }
    }
}

/*
struct RoutineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineDetailView()
    }
}
*/
