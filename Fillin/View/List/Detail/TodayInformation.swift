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
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var incrementPerTap: IncrementPerTap
    @State var tappingMinus = false
    @State var tappingPlus = false
    @State var isExpanded = false
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text("\(habit.achievement[selectedDate.dictKey] ?? 0)\(" times".localized)/\(habit.numberOfTimes)\(" times".localized)")
                        .foregroundColor(habit.color)
                        .headline()
                    Spacer()
                }
                HStack {
                    LinearProgressBar(
                        color: habit.color,
                        progress: Double(habit.achievement[selectedDate.dictKey] ?? 0)/Double(habit.numberOfTimes)
                    )
                    moveButton(isAdd: false)
                        .subColor()
                    moveButton(isAdd: true)
                        .subColor()
                }
            }
            .rowBackground()
            if let id = habit.id, isExpanded {
                AddUnitRow(habitID: id)
            }
        }
    }
    func moveButton(isAdd: Bool) -> some View {
        var buttonName: String {
            if isAdd {
                return isExpanded ? "xmark" : "plus"
            } else { return "minus" }
        }
        return LongPressButton(
            imageSystemName: buttonName,
            onTapFunc: {
                guard isExpanded == false else {
                    isExpanded = false
                    return
                }
                guard let id = habit.id else {
                    return
                }
                let addVal = Int16(incrementPerTap.addUnit[id] ?? 1)
                withAnimation {
                    if isAdd {
                        habit.achievement[selectedDate.dictKey] =
                            (habit.achievement[selectedDate.dictKey] ?? 0) + addVal
                    } else {
                        habit.achievement[selectedDate.dictKey] =
                            max(0, (habit.achievement[selectedDate.dictKey] ?? 0) - addVal)
                    }
                }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                Habit.coreDataSave(managedObjectContext)
            }, longTapFunc: {
                withAnimation {
                    self.isExpanded = true
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        )
    }
}

/*
 struct TodayHabit_Previews: PreviewProvider {
 static var previews: some View {
 TodayHabit()
 }
 }
 */
