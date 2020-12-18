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
    @EnvironmentObject var addUnit: AddUnit
    @State var tappingMinus = false
    @State var tappingPlus = false
    @State var isExpanded = false
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "minus")
                    .font(.system(size: 25))
                    .frame(width: 40, height: 40)
                    .foregroundColor(ThemeColor.mainColor)
                    .onTapGesture {
                        if isExpanded {
                            isExpanded = false
                            return
                        }
                        if habit.achieve[selectedDate.dictKey] != nil {
                            habit.achieve[selectedDate.dictKey]! -= Int16(addUnit.addUnit[habit.id] ?? 1)
                            habit.achieve[selectedDate.dictKey] = max(0, habit.achieve[selectedDate.dictKey]!)
                        } else {
                            habit.achieve[selectedDate.dictKey] = Int16(addUnit.addUnit[habit.id] ?? 1)
                        }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        CoreDataManager.save(managedObjectContext)
                    }
                    .onLongPressGesture(
                        minimumDuration: 0.4,
                        pressing: { isPressing in
                            self.tappingMinus = isPressing
                        },
                        perform: {
                            self.isExpanded = true
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    )
                    .opacity(tappingMinus ? 0.5 : 1.0)
                VStack {
                    Text("\(habit.targetAmount)회 중 \(habit.achieve[selectedDate.dictKey] ?? 0)회")
                        .rowHeadline()
                    Text("\(selectedDate.month)월 \(selectedDate.day)일\(selectedDate.dictKey == Date().dictKey ? "(오늘)" : "")")
                        .rowSubheadline()
                    LinearProgressBar(color: Color(hex: habit.color), progress: Double(habit.achieve[selectedDate.dictKey] ?? 0)/Double(habit.targetAmount))
                        .padding([.trailing, .leading], 5)
                }
                .frame(height: 70)
                .padding([.leading, .trailing], 5)
                Image(systemName: isExpanded ? "xmark" : "plus")
                    .foregroundColor(ThemeColor.mainColor)
                    .font(.system(size: 25))
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        if isExpanded {
                            isExpanded = false
                            return
                        }
                        if habit.achieve[selectedDate.dictKey] != nil {
                            habit.achieve[selectedDate.dictKey]! += Int16(addUnit.addUnit[habit.id] ?? 1)
                        } else {
                            habit.achieve[selectedDate.dictKey] = Int16(addUnit.addUnit[habit.id] ?? 1)
                        }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        CoreDataManager.save(managedObjectContext)
                    }
                    .onLongPressGesture(
                        minimumDuration: 0.4,
                        pressing: { isPressing in
                            self.tappingPlus = isPressing
                        },
                        perform: {
                            self.isExpanded = true
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    )
                    .opacity(tappingPlus ? 0.5 : 1.0)
            }
            .rowBackground()
            if isExpanded {
                AddUnitRow(id: habit.id)
            }
        }
    }
}

/*
 struct TodayHabit_Previews: PreviewProvider {
 static var previews: some View {
 TodayHabit()
 }
 }
 */
