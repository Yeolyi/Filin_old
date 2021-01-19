//
//  MainRow.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI
import AVFoundation

struct HabitRow: View {
    
    @ObservedObject var habit: HabitContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    @State var isTapping = false
    let date: Date
    let showAdd: Bool
    
    init(habit: HabitContext, showAdd: Bool, date: Date = Date()) {
        self.habit = habit
        self.showAdd = showAdd
        self.date = date
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
        HStack(spacing: 0) {
            if showAdd {
                CheckButton(date: date)
                    .environmentObject(habit)
            }
            NavigationLink(destination:
                            HabitDetailView(habit: habit).environmentObject(habit)
            ) {
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
                    if habit.dayOfWeek.contains(appSetting.mainDate.dayOfTheWeek) {
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
            }
            .padding(.leading, 5)
        }
        .rowBackground()
    }
}

struct HabitRow_Previews: PreviewProvider {
    static var previews: some View {
        let coredataPreview = CoreDataPreview.shared
        HabitRow(habit: HabitContext(name: "Test"),showAdd: true)
            .environmentObject(coredataPreview.habitcontextManager)
    }
}
