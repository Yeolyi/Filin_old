//
//  Test2.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct Test2: View {
    
    @Binding var habitType: HabitType
    @Binding var dayOfTheWeek: [Int]
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: "calendar")
                .font(.system(size: 70, weight: .semibold))
                .foregroundColor(color)
                .padding(.bottom, 10)
                .padding(.top, 70)
            Text("주기 설정")
                .title()
                .padding(.bottom, 100)
            Text("주기")
                .sectionText()
            Picker("Map type", selection: $habitType) {
                Text("매일").tag(HabitType.daily)
                Text("매주").tag(HabitType.weekly)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.leading, .trailing], 30)
            if habitType == .weekly {
                HStack {
                    Spacer()
                    ForEach(1..<8) { dayOfTheWeekInt in
                        Button(action: {
                            if dayOfTheWeek.contains(dayOfTheWeekInt) {
                                dayOfTheWeek.remove(at: dayOfTheWeek.firstIndex(of: dayOfTheWeekInt)!)
                            } else {
                                dayOfTheWeek.append(dayOfTheWeekInt)
                            }
                        }) {
                            ZStack {
                                CircleProgress(progress: 0, color: color, num: Date.dayOfTheWeekStr(dayOfTheWeekInt), isUnderBar: false, highlighted: false, activated: dayOfTheWeek.contains(dayOfTheWeekInt))
                                    .frame(width: 40, height: 40)
                                    .zIndex(0)
                            }
                        }
                    }
                    Spacer()
                }
                .padding([.leading, .trailing], 10)
            }
            Spacer()
        }
    }
}

struct Test2_Previews: PreviewProvider {
    static var previews: some View {
        Test2(habitType: .constant(.weekly), dayOfTheWeek: .constant([]), color: .blue)
    }
}
