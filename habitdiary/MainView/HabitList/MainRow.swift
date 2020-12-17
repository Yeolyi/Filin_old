//
//  MainRow.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI
import AVFoundation

struct MainRow: View {
    
    @ObservedObject var habit: HabitInfo
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var addUnit: AddUnit
    @State var isExpanded = false
    @State var tapping = false
    let showAdd: Bool
    let showCheck: Bool
    
    var subTitle: String {
        var subTitleStr = ""
        if habit.habitType == HabitType.weekly.rawValue && habit.targetDays != nil {
            for dayOfWeekInt16 in habit.targetDays! {
                subTitleStr += "\(Date.dayOfTheWeekStr(Int(dayOfWeekInt16))), "
            }
            let _ = subTitleStr.popLast()
            let _ = subTitleStr.popLast()
        } else {
            subTitleStr += "매일"
        }
        subTitleStr += " \(habit.targetAmount)회"
        return subTitleStr
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                if showAdd {
                    Image(systemName: isExpanded ? "xmark" : (showCheck ? "checkmark.circle.fill" : "circle"))
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Color(hex: "#404040"))
                        .frame(width: 50, height: 60)
                        .onTapGesture {
                            if isExpanded {
                                isExpanded = false
                                return
                            }
                            if habit.achieve[Date().dictKey] != nil {
                                habit.achieve[Date().dictKey]! += Int16(addUnit.addUnit[habit.id] ?? 1)
                            } else {
                                habit.achieve[Date().dictKey] = Int16(addUnit.addUnit[habit.id] ?? 1)
                            }
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            CoreDataManager.save(managedObjectContext)
                        }
                        .onLongPressGesture(
                            minimumDuration: 0.4,
                            pressing: { isPressing in
                                self.tapping = isPressing
                            },
                            perform: {
                                self.isExpanded = true
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                        )
                        .opacity(tapping ? 0.5 : 1.0)
                }
                Group {
                    HStack {
                        ZStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(habit.name)
                                        .font(.system(size: 20))
                                    Text(subTitle)
                                        .font(.system(size: 14, weight: .light))
                                }
                                Spacer()
                                LinearProgressBar(color: Color(hex: habit.color), progress: Double(habit.achieve[Date().dictKey] ?? 0)/Double(habit.targetAmount))
                                    .frame(width: 150)
                            }
                            NavigationLink(destination: HabitViewMain(habit: habit)) {
                                Rectangle()
                                    .opacity(0)
                            }
                        }
                    }
                    .frame(height: 60)
                }
                .padding([.leading], showAdd ? 5 : 10)
            }
            .rowBackground()
            if isExpanded {
                AddUnitRow(id: habit.id)
            }
        }
    }
}



