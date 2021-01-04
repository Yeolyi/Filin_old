//
//  MainRow.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI
import AVFoundation

struct HabitRow: View {
    
    @ObservedObject var habit: Habit
    let date: Date
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var addUnit: IncrementPerTap
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
        if !habit.isDaily {
            for dayOfWeekInt16 in habit.dayOfWeek {
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
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if showAdd {
                    CheckButton(date: date, habit: habit)
                }
                ZStack {
                    HStack {
                        VStack {
                            HStack {
                                Text(subTitle)
                                    .bodyText()
                                Spacer()
                            }
                            HStack {
                                Text(habit.name)
                                    .foregroundColor(habit.color)
                                    .headline()
                                Spacer()
                            }
                        }
                        if habit.dayOfWeek.contains(Int16(date.dayOfTheWeek)) {
                            ZStack {
                                LinearProgressBar(color: habit.color, progress: habit.progress(at: date) ?? 0)
                                HStack {
                                    Spacer()
                                    Text("\(habit.achievement[date.dictKey] ?? 0)/\(habit.numberOfTimes)")
                                        .mainColor()
                                        .opacity(0.8)
                                        .bodyText()
                                        .padding(.trailing, 5)
                                }
                                .zIndex(1)
                            }
                            .frame(width: 150, height: 20)
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
        }
    }
}
