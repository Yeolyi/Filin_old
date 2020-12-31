//
//  HabitCheckButton.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI
import AVFoundation

struct HabitCheckButton: View {
    @Binding var isExpanded: Bool
    var showCheck: Bool {
        habit.isComplete(at: date)
    }
    let date: Date
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var incrementPerTap: IncrementPerTap
    let habit: Habit
    var body: some View {
        if habit.requiredSecond == 0 {
            LongPressButton(
                imageSystemName: isExpanded ? "xmark" : (showCheck ? "checkmark.circle.fill" : "plus.circle"),
                onTapFunc: {
                    if isExpanded {
                        withAnimation { isExpanded = false }
                        return
                    }
                    guard let id = habit.id else {
                        return
                    }
                    let addedVal = Int16(incrementPerTap.addUnit[id] ?? 1)
                    withAnimation {
                        habit.achievement[date.dictKey] = (habit.achievement[date.dictKey] ?? 0) + addedVal
                    }
                    /*
                    if habit.progress(at: date) == 1.0 {
                        let systemSoundID: SystemSoundID = 1016
                        AudioServicesPlaySystemSound (systemSoundID)
                    }
 */
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    Habit.coreDataSave(managedObjectContext)
                },
                longTapFunc: {
                    withAnimation { self.isExpanded = true }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            )
            .foregroundColor(habit.color)
        } else {
            NavigationLink(
                destination:
                    HabitTimer(habit: habit, date: date)
            ) {
                Image(systemName: showCheck ? "clock.fill" : "clock")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(habit.color)
                    .frame(width: 44, height: 44)
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
