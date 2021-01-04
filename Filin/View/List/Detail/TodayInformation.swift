//
//  TodayHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct TodayInformation: View {
    
    @ObservedObject var habit: Habit
    @Binding var selectedDate: Date
    @State var tappingMinus = false
    @State var tappingPlus = false
    @State var isSetMode = true
    @State var isExpanded = false
    
    var setAvailable: Bool {
        guard let id = habit.id else {
            return false
        }
        return !(incrementPerTap.addUnit[id] == 1 || incrementPerTap.addUnit[id] == nil)
    }
    
    var addedVal: Int16 {
        guard let id = habit.id else {
            return 1
        }
        return Int16(incrementPerTap.addUnit[id] ?? 1)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(habit.achievement[selectedDate.dictKey] ?? 0)\(" times".localized)/\(habit.numberOfTimes)\(" times".localized)")
                    .foregroundColor(habit.color)
                    .headline()
                Spacer()
                if setAvailable {
                    BasicTextButton(isSetMode ? "±\(addedVal)" : "±1") { isSetMode.toggle() }
                }
            }
            HStack {
                LinearProgressBar(
                    color: habit.color,
                    progress: Double(habit.achievement[selectedDate.dictKey] ?? 0)/Double(habit.numberOfTimes)
                )
                moveButton(isAdd: false)
                moveButton(isAdd: true)
            }
            if isExpanded {
                HabitStatistics(habit: habit)
                    .padding(.top, 15)
            }
            BasicButton(isExpanded ? "chevron.compact.up" : "chevron.compact.down") {
                withAnimation {
                    self.isExpanded.toggle()
                }
            }
        }
        .rowBackground()
    }
    func moveButton(isAdd: Bool) -> some View {
        BasicButton(isAdd ? "plus" : "minus") {
            let addVal = isSetMode ? addedVal : 1
            withAnimation {
                if isAdd {
                    habit.achievement[selectedDate.dictKey] =
                        (habit.achievement[selectedDate.dictKey] ?? 0) + addVal
                } else {
                    habit.achievement[selectedDate.dictKey] =
                        max(0, (habit.achievement[selectedDate.dictKey] ?? 0) - addVal)
                }
            }
            if habit.achievement[selectedDate.dictKey] == 0 {
                habit.achievement[selectedDate.dictKey] = nil
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            Habit.save(managedObjectContext)
        }
    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var incrementPerTap: IncrementPerTap
    
}

struct TodayHabit_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview()
        coreDataPreview.incrementPerTap.addUnit[coreDataPreview.habit1.id!] = 5
        return TodayInformation(habit: coreDataPreview.habit1, selectedDate: .constant(Date()))
            .environmentObject(IncrementPerTap())
    }
}
