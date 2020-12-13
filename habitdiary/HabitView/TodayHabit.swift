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
    
    var body: some View {
        VStack {
            if selectedDate.dictKey == Date().dictKey {
                Text("오늘의 기록")
            } else {
                Text("\(selectedDate.month)월 \(selectedDate.day)일의 기록")
                    .font(.system(size: 16, weight: .semibold))
            }
            Text("\(habit.times)회 중 \(habit.achieve[selectedDate.dictKey] ?? 0)회 완료")
                .font(.system(size: 16, weight: .light))
            HStack {
                Button(action: {
                    if habit.achieve[selectedDate.dictKey] != nil {
                        habit.achieve[selectedDate.dictKey]! = max(0, habit.achieve[selectedDate.dictKey]!-1)
                    }
                    CoreDataManager.save(managedObjectContext)
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 25, weight: .light))
                        .frame(width: 30, height: 30)
                }
                LinearProgressBar(color: Color(str: habit.color), progress: Double(habit.achieve[selectedDate.dictKey] ?? 0)/Double(habit.times))
                    .padding([.trailing, .leading], 5)
                Button(action: {
                    if habit.achieve[selectedDate.dictKey] != nil {
                        habit.achieve[selectedDate.dictKey]! += 1
                    } else {
                        habit.achieve[selectedDate.dictKey] = 1
                    }
                    CoreDataManager.save(managedObjectContext)
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 25, weight: .light))
                        .frame(width: 30, height: 30)
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
