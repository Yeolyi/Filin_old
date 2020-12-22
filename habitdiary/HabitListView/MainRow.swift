//
//  MainRow.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI
import AVFoundation

struct MainRow: View {
    @ObservedObject var habit: Habit
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var addUnit: IncrementPerTap
    @State var isExpanded = false
    @State var isTapping = false
    let showAdd: Bool
    let showCheck: Bool
    var subTitle: String {
        var subTitleStr = ""
        if habit.type == HabitType.weekly.string && habit.dayOfWeek != nil {
            subTitleStr = "\("Every week".localized) "
            for dayOfWeekInt16 in habit.dayOfWeek! {
                subTitleStr += "\(Date.dayOfTheWeekStr(Int(dayOfWeekInt16))), "
            }
            _ = subTitleStr.popLast()
            _ = subTitleStr.popLast()
        } else {
            subTitleStr = "Every day".localized
        }
        return subTitleStr
    }
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                if showAdd {
                    LongPressButton(
                        imageSystemName: isExpanded ? "xmark" : (showCheck ? "checkmark.circle.fill" : "circle"),
                        onTapFunc: {
                            if isExpanded {
                                withAnimation { isExpanded = false }
                                return
                            }
                            let addedVal = Int16(addUnit.addUnit[habit.id] ?? 1)
                            withAnimation {
                                habit.achievement[Date().dictKey] = (habit.achievement[Date().dictKey] ?? 0) + addedVal
                            }
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            CoreDataManager.save(managedObjectContext)
                        },
                        longTapFunc: {
                            withAnimation { self.isExpanded = true }
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    )
                }
                ZStack {
                    HStack {
                        VStack {
                            HStack {
                                Text(habit.name)
                                    .rowHeadline()
                                Spacer()
                            }
                            HStack {
                                Text(subTitle)
                                    .rowSubheadline()
                                Spacer()
                            }
                        }
                        VStack(alignment: .trailing) {
                            LinearProgressBar(color: Color(hex: habit.color), progress: habit.progress(at: Date()))
                                .frame(width: 150)
                            Text("\(habit.achievement[Date().dictKey] ?? 0)\(" times".localized)/\(habit.timesToComplete)\(" times".localized)")
                                .rowSubheadline()
                        }
                    }
                    NavigationLink(destination: HabitViewMain(habit: habit)) {
                        Rectangle()
                            .opacity(0)
                    }
                }
                .padding(.leading, 5)
            }
            .rowBackground()
            if isExpanded {
                AddUnitRow(habitID: habit.id)
            }
        }
    }
}
