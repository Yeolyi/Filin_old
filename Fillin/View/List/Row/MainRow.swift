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
    let date: Date
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var addUnit: IncrementPerTap
    @State var isExpanded = false
    @State var isTapping = false
    init(habit: Habit, showAdd: Bool, date: Date = Date()) {
        self.habit = habit
        self.showAdd = showAdd
        self.date = date
    }
    let showAdd: Bool
    var showCheck: Bool {
        habit.isComplete(at: date)
    }
    var subTitle: String {
        var subTitleStr = ""
        if habit.cycleType == HabitCycleType.weekly {
            for dayOfWeekInt16 in habit.dayOfWeek ?? [] {
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
                    HabitCheckButton(isExpanded: $isExpanded, date: date, habit: habit)
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
                            LinearProgressBar(color: habit.color, progress: habit.progress(at: date) ?? 0)
                                .frame(width: 150)
                            Text("\(habit.achievement[date.dictKey] ?? 0)\(" times".localized)/\(habit.numberOfTimes)\(" times".localized)")
                                .rowSubheadline()
                        }
                    }
                    NavigationLink(destination: HabitDetailView(habit: habit)) {
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
