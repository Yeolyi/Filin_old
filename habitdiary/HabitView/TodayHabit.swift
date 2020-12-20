//
//  TodayHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct TodayHabit: View {
    @ObservedObject var habit: HabitInfo
    @Binding var selectedDate: Date
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var addUnit: IncrementPerTap
    @State var tappingMinus = false
    @State var tappingPlus = false
    @State var isExpanded = false
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                moveButton(isAdd: false)
                VStack {
                    Text("\(habit.targetAmount)회 중 \(habit.achieve[selectedDate.dictKey] ?? 0)회")
                        .rowHeadline()
                    Text("""
\(selectedDate.month)월 \(selectedDate.day)일\(selectedDate.dictKey == Date().dictKey ? "(오늘)" : "")
""")
                        .rowSubheadline()
                    LinearProgressBar(
                        color: Color(hex: habit.color),
                        progress: Double(habit.achieve[selectedDate.dictKey] ?? 0)/Double(habit.targetAmount)
                    )
                    .padding([.trailing, .leading], 5)
                    .frame(maxWidth: 400)
                }
                .frame(height: 70)
                .padding([.leading, .trailing], 5)
                moveButton(isAdd: true)
            }
            .rowBackground()
            if isExpanded {
                AddUnitRow(habitID: habit.id)
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
                let addVal = Int16(addUnit.addUnit[habit.id] ?? 1)
                if isAdd {
                    habit.achieve[selectedDate.dictKey] =
                        (habit.achieve[selectedDate.dictKey] ?? 0) + addVal
                } else {
                    habit.achieve[selectedDate.dictKey] =
                        max(0, (habit.achieve[selectedDate.dictKey] ?? 0) - addVal)
                }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                CoreDataManager.save(managedObjectContext)
            }, longTapFunc: {
                self.isExpanded = true
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
