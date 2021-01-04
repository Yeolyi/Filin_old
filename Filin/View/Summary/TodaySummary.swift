//
//  TodaySummary.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/21.
//

import SwiftUI

struct TodaySummary: View {
   
    var habit: [Habit] = []
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack(spacing: 0) {
            if !summaryProfile.isEmpty {
                ForEach(summaryProfile[0].idArray.compactMap({$0}).uniqueValues, id: \.self) { habitID in
                    idToRow(id: habitID)
                }
            }
        }
    }
    func idToRow(id: UUID) -> AnyView {
        guard let habit = habitInfos.first(where: {$0.id == id}) else {
            return AnyView(EmptyView())
        }
        return AnyView(
            HabitRow(habit: habit, showAdd: false, date: selectedDate)
        )
    }
    
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Summary.entity(),
        sortDescriptors: []
    )
    var summaryProfile: FetchedResults<Summary>
}

struct TodaySummary_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview()
        return TodaySummary(selectedDate: .constant(Date()))
            .environment(\.managedObjectContext, coreDataPreview.context)
    }
}

extension Array where Element: Hashable {
    var uniqueValues: [Element] {
        var allowed = Set(self)
        return compactMap { allowed.remove($0) }
    }
}
