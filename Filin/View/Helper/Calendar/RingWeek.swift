//
//  CalendarWeek.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct RingWeek: View {

    let week: Int
    let isExpanded: Bool
    @ObservedObject var habitsWrapped: CalendarHabitWrapper
    @Binding var selectedDate: Date
    
    init(week: Int, isExpanded: Bool, habits: [Habit?], selectedDate: Binding<Date>) {
        self.week = week
        self.isExpanded = isExpanded
        self.habitsWrapped = CalendarHabitWrapper(habits: habits)
        self._selectedDate = selectedDate
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(selectedDate.containedWeek(week: week), id: \.self) { date in
                CircleProgress(getRingTuple(at: date)) {
                    Text(Date().dictKey == date.dictKey ? "✓" : String(date.day))
                        .foregroundColor(textColor(at: date))
                        .bodyText()
                }
                .onTapGesture {
                    selectedDate = date
                }
            }
        }
        .padding(.bottom, 10)
    }
    
    func isButtonActive(at date: Date) -> Bool {
        if habitsWrapped.habitNum != 1 {
            return true
        } else {
            return habitsWrapped.compact[0].isTodo(at: date.dayOfTheWeek) == true
        }
    }
    
    func getRingTuple(at date: Date) -> [(Double, Color)?] {
        guard isButtonActive(at: date) else {
            return [(0, .clear), nil, nil]
        }
        var tempRingTuple: [(Double, Color)?] = []
        for habit in habitsWrapped.value {
            guard let habit = habit else {
                tempRingTuple.append(nil)
                continue
            }
            guard let progress = habit.progress(at: date), progress > 0 else {
                tempRingTuple.append((0, .clear))
                continue
            }
            let color = (selectedDate.month == date.month) ? habit.color : ThemeColor.subColor(colorScheme)
            tempRingTuple.append((progress, color))
        }
        if tempRingTuple.compactMap({$0}).isEmpty {
            let colorInactive = ThemeColor.subColor(colorScheme).opacity(0.05)
            tempRingTuple[2] = (1, colorInactive)
        }
        return tempRingTuple
    }
    
    func textColor(at date: Date) -> Color {
        guard isButtonActive(at: date) else {
            return ThemeColor.subColor(colorScheme)
        }
        if selectedDate.month != date.month && isExpanded {
            return ThemeColor.subColor(colorScheme)
        } else if habitsWrapped.habitNum == 0 {
            return ThemeColor.mainColor(colorScheme)
        } else if date.dictKey == selectedDate.dictKey {
            if let colorHex = habitsWrapped.value[0]?.color {
                return colorHex
            } else {
                return ThemeColor.subColor(colorScheme)
            }
        }
        return ThemeColor.mainColor(colorScheme)
    }
    
    @Environment(\.colorScheme) var colorScheme
    
}
