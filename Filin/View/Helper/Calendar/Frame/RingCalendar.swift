//
//  RingsCalendar.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/10.
//

import SwiftUI

struct RingCalendar: View {
    
    @Binding var selectedDate: Date
    @State var isExpanded = false
    @State var isEmojiView = false
    
    @ObservedObject var habit1: FlHabit
    @ObservedObject var habit2: FlHabit
    @ObservedObject var habit3: FlHabit
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    
    var habitsWrapped: [FlHabit?] {
        [
            habit1.requiredSec == -1 ? nil : habit1,
            habit2.requiredSec == -1 ? nil : habit2,
            habit3.requiredSec == -1 ? nil : habit3
        ]
    }
    
    var color: Color {
        if habitsWrapped.compactMap({$0}).isEmpty {
            return ThemeColor.mainColor(colorScheme)
        } else {
            return habitsWrapped.compactMap({$0})[0].color
        }
    }
    
    init(selectedDate: Binding<Date>, isExpanded: Bool = false,
         isEmojiView: Bool = false,
         habit1: FlHabit? = nil, habit2: FlHabit? = nil, habit3: FlHabit? = nil) {
        self._selectedDate = selectedDate
        self._isExpanded = State(initialValue: isExpanded)
        self._isEmojiView = State(initialValue: isEmojiView)
        let nilHabit = FlHabit(name: "Nil")
        nilHabit.requiredSec = -1
        self.habit1 = habit1 == nil ? nilHabit : habit1!
        self.habit2 = habit2 == nil ? nilHabit : habit2!
        self.habit3 = habit3 == nil ? nilHabit : habit3!
    }
    
    var body: some View {
        CalendarInterface(selectedDate: $selectedDate, color: color, isExpanded: $isExpanded, isEmojiView: $isEmojiView, move: move, content: { week, isExpanded -> AnyView in
            if isEmojiView && !habitsWrapped.compactMap({$0}).isEmpty {
                return AnyView(EmojiCalendarRow(week: week, isExpanded: isExpanded, selectedDate: $selectedDate, habit: habitsWrapped.compactMap({$0})[0]))
            } else {
                return AnyView(HStack(spacing: 8) {
                    ForEach(selectedDate.containedWeek(week: week, from: appSetting.isMondayStart ? 2 : 1), id: \.self) { date in
                        CircleProgress(CalendarRingDesign.getRingTuple(
                                        at: date, habits: habitsWrapped, selectedDate: selectedDate, colorScheme: colorScheme
                        )) {
                            Text(appSetting.mainDate.dictKey == date.dictKey ? "✓" : String(date.day))
                                .foregroundColor(
                                    CalendarRingDesign.textColor(
                                        at: date, habits: habitsWrapped, selectedDate: selectedDate,
                                        isExpanded: isExpanded, colorScheme: colorScheme)
                                )
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
                return selectedDate.monthShift(contains: Array(habit.dayOfWeek), isAdd: isAdd)
            } else {
                return Calendar.current.date(byAdding: .month, value: addedValue, to: selectedDate) ?? Date()
            }
        } else {
            return Calendar.current.date(byAdding: .weekOfMonth, value: addedValue, to: selectedDate) ?? Date()
        }
    }

}

/*
 struct CustomCalendar_Previews: PreviewProvider {
 static var previews: some View {
 CalendarRow(selectedDate: .constant(Date()), habit: , isExpanded: true)
 }
 }
 */
