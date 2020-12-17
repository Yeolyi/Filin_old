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
    
    var body: some View {
        HStack(spacing: 0) {
            Group {
                Button(action: {
                    if habit.achieve[selectedDate.dictKey] != nil {
                        habit.achieve[selectedDate.dictKey]! = max(0, habit.achieve[selectedDate.dictKey]!-Int16(addUnit.addUnit[habit.id] ?? 1))
                    }
                    CoreDataManager.save(managedObjectContext)
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 25, weight: .light))
                        .frame(width: 30, height: 70)
                        .rowBackground()
                }
            }
            .frame(width: 70)
            .padding([.top, .bottom], 5)
            Group {
                VStack {
                    if selectedDate.dictKey == Date().dictKey {
                        Text("오늘의 기록")
                            .font(.system(size: 16, weight: .semibold))
                    } else {
                        Text("\(selectedDate.month)월 \(selectedDate.day)일의 기록")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text("\(habit.targetAmount)회 중 \(habit.achieve[selectedDate.dictKey] ?? 0)회 완료")
                        .font(.system(size: 16, weight: .light))
                    LinearProgressBar(color: Color(hex: habit.color), progress: Double(habit.achieve[selectedDate.dictKey] ?? 0)/Double(habit.targetAmount))
                        .padding([.trailing, .leading], 5)
                }
                .frame(height: 70)
                .rowBackground()
            }
            .padding([.leading, .trailing], 5)
            Group {
                Button(action: {
                    if habit.achieve[selectedDate.dictKey] != nil {
                        habit.achieve[selectedDate.dictKey]! += Int16(addUnit.addUnit[habit.id] ?? 1)
                    } else {
                        habit.achieve[selectedDate.dictKey] = Int16(addUnit.addUnit[habit.id] ?? 1)
                    }
                    CoreDataManager.save(managedObjectContext)
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Image(systemName: habit.achieve[Date().dictKey] ?? 0 >= habit.targetAmount ? "checkmark" : "plus")
                        .font(.system(size: 25, weight: .light))
                        .frame(width: 30, height: 70)
                        .rowBackground()
                }
            }
            .frame(width: 70)
            .padding([.top, .bottom], 5)
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
