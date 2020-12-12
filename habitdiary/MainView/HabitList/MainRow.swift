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
    
    var body: some View {
        ZStack {
            HStack {
                ZStack {
                    HStack {
                        Text(habit.name)
                            .font(.system(size: 20, weight: .light, design: .default))
                        Spacer()
                        HabitGauge(color: Color(str: habit.color), times: habit.times, achieve: habit.achieve[Date().dictKey] ?? 0)
                    }
                    NavigationLink(destination: HabitViewMain(habit: habit)) {
                        Rectangle()
                            .opacity(0)
                    }
                }
                Button(action: {
                    if habit.achieve[Date().dictKey] != nil {
                        habit.achieve[Date().dictKey]! += 1
                    } else {
                        habit.achieve[Date().dictKey] = 1
                    }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 25))
                }
            }
            .padding([.top, .bottom], 10)
            .rowBackground()
        }
    }
}



