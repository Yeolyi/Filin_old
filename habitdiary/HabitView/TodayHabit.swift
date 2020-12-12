//
//  TodayHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct TodayHabit: View {
    
    let habit: HabitInfo
    @Binding var selectedDate: Date
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        VStack {
            Text("오늘의 기록")
                .font(.system(size: 16, weight: .semibold))
            HStack {
                Text("\(habit.achieve[selectedDate.dictKey] ?? 0)/\(habit.times)")
                Spacer()
                HabitGauge(color: Color(str: habit.color), times: habit.times, achieve: habit.achieve[selectedDate.dictKey] ?? 0)
                Button(action: {
                    if habit.achieve[selectedDate.dictKey] != nil {
                        habit.achieve[selectedDate.dictKey]! = max(0, habit.achieve[selectedDate.dictKey]!-1)
                    }
                    CoreDataManager.save(managedObjectContext)
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 25, weight: .light))
                        .padding(10)
                }
                Button(action: {
                    if habit.achieve[selectedDate.dictKey] != nil {
                        habit.achieve[selectedDate.dictKey]! += 1
                    } else {
                        habit.achieve[selectedDate.dictKey] = 1
                    }
                    CoreDataManager.save(managedObjectContext)
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 25, weight: .light))
                        .padding(10)
                }
            }
        }
        .rowBackground()
    }
}

/*
 struct TodayHabit_Previews: PreviewProvider {
 static var previews: some View {
 TodayHabit()
 }
 }
 */
