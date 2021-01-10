//
//  TodayHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct TodayInformation: View {
    
    @EnvironmentObject var habit: HabitContext
    @Binding var selectedDate: Date
    @State var tappingMinus = false
    @State var tappingPlus = false
    @State var isSetMode = true
    @State var isExpanded = false
    
    var setAvailable: Bool {
        return habit.addUnit != 1
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(habit.achievement[selectedDate.dictKey] ?? 0)\(" times".localized)/\(habit.numberOfTimes)\(" times".localized)")
                    .foregroundColor(habit.color)
                    .headline()
                Spacer()
                if setAvailable {
                    BasicTextButton(isSetMode ? "±\(habit.addUnit)" : "±1") { isSetMode.toggle() }
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
            let addVal = isSetMode ? habit.addUnit : 1
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
        }
    }
    
}
