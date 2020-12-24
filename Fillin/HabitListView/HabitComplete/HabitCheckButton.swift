//
//  HabitCheckButton.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI

struct HabitCheckButton: View {
    @Binding var isExpanded: Bool
    var showCheck: Bool {
        habit.isComplete(at: date)
    }
    let date: Date
    @Environment(\.managedObjectContext) var managedObjectContext
    let habit: Habit
    @EnvironmentObject var addUnit: IncrementPerTap
    var body: some View {
        if habit.requiredSecond == 0 {
            LongPressButton(
                imageSystemName: isExpanded ? "xmark" : (showCheck ? "checkmark.circle.fill" : "circle"),
                onTapFunc: {
                    if isExpanded {
                        withAnimation { isExpanded = false }
                        return
                    }
                    let addedVal = Int16(addUnit.addUnit[habit.id] ?? 1)
                    withAnimation {
                        habit.achievement[date.dictKey] = (habit.achievement[date.dictKey] ?? 0) + addedVal
                    }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    CoreDataManager.save(managedObjectContext)
                },
                longTapFunc: {
                    withAnimation { self.isExpanded = true }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            )
        } else {
            NavigationLink(
                destination:
                    HabitTimer(habit: habit, date: date)
            ) {
                Image(systemName: showCheck ? "clock.fill" : "clock")
                    .font(.system(size: 22, weight: .semibold))
                    .mainColor()
                    .frame(width: 50, height: 60)
            }
        }
    }
}

/*
struct HabitCheckButton_Previews: PreviewProvider {
    static var previews: some View {
        HabitCheckButton()
    }
}
*/
