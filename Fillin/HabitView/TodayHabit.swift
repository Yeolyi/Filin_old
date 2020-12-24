//
//  TodayHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct TodayHabit: View {
    @ObservedObject var habit: Habit
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
                    Text("\(habit.timesToComplete)\(" out of".localized) \(habit.achievement[selectedDate.dictKey] ?? 0)\(" times".localized)")
                        .rowHeadline()
                    Text("""
\(selectedDate.localizedMonthDay)\(selectedDate.dictKey == Date().dictKey ? "(\("Today".localized))" : "")
""")
                        .rowSubheadline()
                    LinearProgressBar(
                        color: Color(hex: habit.color),
                        progress: Double(habit.achievement[selectedDate.dictKey] ?? 0)/Double(habit.timesToComplete)
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
                CoreDataManager.save(managedObjectContext)
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
