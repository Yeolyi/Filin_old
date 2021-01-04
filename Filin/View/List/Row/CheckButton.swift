//
//  HabitCheckButton.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI
import AVFoundation

struct CheckButton: View {

    var showCheck: Bool {
        habit.isComplete(at: date)
    }
    let date: Date
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var incrementPerTap: IncrementPerTap
    let habit: Habit
    
    var body: some View {
        if habit.requiredSecond == 0 {
            Button(action: {
                guard let id = habit.id else {
                    return
                }
                let addedVal = Int16(incrementPerTap.addUnit[id] ?? 1)
                withAnimation {
                    habit.achievement[date.dictKey] = (habit.achievement[date.dictKey] ?? 0) + addedVal
                }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                Habit.save(managedObjectContext)
            }) {
                Image(systemName: showCheck ? "checkmark.circle.fill" : "plus.circle")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(habit.color)
                    .frame(width: 44, height: 44)
            }
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
