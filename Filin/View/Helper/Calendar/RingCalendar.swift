//
//  CustomCalendar.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct RingCalendar: View {
    
    @Binding var selectedDate: Date
    @State var isExpanded = false
    @State var isEmojiView = false
    
    @ObservedObject var habit: HabitContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    
    var habitsWrapped: [HabitContext?] {
        [habit, nil, nil]
    }
    
    var color: Color {
        if habitsWrapped.compactMap({$0}).isEmpty {
            return ThemeColor.mainColor(colorScheme)
        } else {
            return habitsWrapped.compactMap({$0})[0].color
        }
    }
    
    init(selectedDate: Binding<Date>, isExpanded: Bool = false, habit: HabitContext) {
        self._selectedDate = selectedDate
        self._isExpanded = State(initialValue: isExpanded)
        self.habit = habit
    }
    
    var body: some View {
        CalendarInterface(selectedDate: $selectedDate, color: color, isExpanded: $isExpanded, isEmojiView: $isEmojiView, move: move, content: { week, isExpanded -> AnyView in
                if isEmojiView && !habitsWrapped.compactMap({$0}).isEmpty {
                    return AnyView(EmojiCalendarRow(week: week, isExpanded: isExpanded, habit: habitsWrapped.compactMap({$0})[0], selectedDate: $selectedDate))
                } else {
                    return AnyView(HStack(spacing: 8) {
                        ForEach(selectedDate.containedWeek(week: week, from: appSetting.isMondayStart ? 2 : 1), id: \.self) { date in
                            CircleProgress(getRingTuple(at: date)) {
                                Text(appSetting.mainDate.dictKey == date.dictKey ? "✓" : String(date.day))
                                    .foregroundColor(textColor(at: date))
                                    .bodyText()
                            }
                            .onTapGesture {
                                selectedDate = date
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    )
                }
        })
    }
    
    func move(isAdd: Bool) -> Date {
        let habit = habitsWrapped.compactMap({$0}).first
        let addedValue = isAdd ?  1 : -1
        if isExpanded {
            guard let habit = habit else {
                return Calendar.current.date(byAdding: .month, value: addedValue, to: selectedDate) ?? Date()
            }
            if !habit.isDaily {
                return selectedDate.monthShift(contains: habit.dayOfWeek, isAdd: isAdd)
            } else {
                return Calendar.current.date(byAdding: .month, value: addedValue, to: selectedDate) ?? Date()
            }
        } else {
            return Calendar.current.date(byAdding: .weekOfMonth, value: addedValue, to: selectedDate) ?? Date()
        }
    }
    
    
    func isButtonActive(at date: Date) -> Bool {
        if habitsWrapped.compactMap({$0}).count != 1 {
            return true
        } else {
            return habitsWrapped.compactMap({$0})[0].isTodo(at: date.dayOfTheWeek) == true
        }
    }
    
    func getRingTuple(at date: Date) -> [(Double, Color)?] {
        guard isButtonActive(at: date) else {
            return [(0, .clear), nil, nil]
        }
        var tempRingTuple: [(Double, Color)?] = []
        for habit in habitsWrapped {
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
            tempRingTuple.append((1, colorInactive))
        }
        return tempRingTuple
    }
    
    func textColor(at date: Date) -> Color {
        guard isButtonActive(at: date) else {
            return ThemeColor.subColor(colorScheme)
        }
        if selectedDate.month != date.month && isExpanded {
            return ThemeColor.subColor(colorScheme)
        } else if habitsWrapped.compactMap({$0}).count == 0 {
            return ThemeColor.mainColor(colorScheme)
        } else if date.dictKey == selectedDate.dictKey {
            if let colorHex = habitsWrapped[0]?.color {
                return colorHex
            } else {
                return ThemeColor.subColor(colorScheme)
            }
        }
        return ThemeColor.mainColor(colorScheme)
    }
    
}

/*
 struct CustomCalendar_Previews: PreviewProvider {
 static var previews: some View {
 CalendarRow(selectedDate: .constant(Date()), habit: , isExpanded: true)
 }
 }
 */
