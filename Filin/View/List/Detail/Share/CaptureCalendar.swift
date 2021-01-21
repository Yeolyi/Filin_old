//
//  CaptureCalendar.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/20.
//

import SwiftUI

struct CaptureCalendar: View {
    
    @Binding var showCalendarSelect: Bool
    @Binding var isEmojiView: Bool
    @Binding var selectedDate: Date
    @Binding var isExpanded: Bool
    let habit1: HabitContext
    let habit2: HabitContext
    let habit3: HabitContext
    
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.colorScheme) var colorScheme
    
    var habitsWrapped: [HabitContext?] {
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
    
    init(showCalendarSelect: Binding<Bool>, isEmojiView: Binding<Bool>, isExpanded: Binding<Bool>, selectedDate: Binding<Date>,
         habit1: HabitContext, habit2: HabitContext? = nil, habit3: HabitContext? = nil) {
        self._showCalendarSelect = showCalendarSelect
        self._isEmojiView = isEmojiView
        self._isExpanded = isExpanded
        self._selectedDate = selectedDate
        let nilHabit = HabitContext(name: "Nil")
        nilHabit.requiredSec = -1
        self.habit1 = habit1
        self.habit2 = habit2 == nil ? nilHabit : habit2!
        self.habit3 = habit3 == nil ? nilHabit : habit3!
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if showCalendarSelect {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
            } else {
                HStack {
                    VStack {
                        HStack(alignment: .bottom, spacing: 3) {
                            Text(habit1.name)
                                .foregroundColor(color)
                                .headline()
                            Spacer()
                            Text(selectedDate.localizedYearMonth)
                                .foregroundColor(color)
                                .bodyText()
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 15)
                VStack(spacing: 0) {
                    VStack {
                        if isExpanded {
                            ForEach(1..<selectedDate.weekInMonth(isMondayStart: appSetting.isMondayStart) + 1, id: \.self) { week in
                                if isEmojiView && !habitsWrapped.compactMap({$0}).isEmpty {
                                    EmojiCalendarRow(week: week, isExpanded: isExpanded, selectedDate: $selectedDate, habit: habitsWrapped.compactMap({$0})[0])
                                } else {
                                    HStack(spacing: 8) {
                                        ForEach(selectedDate.containedWeek(week: week, from: appSetting.isMondayStart ? 2 : 1), id: \.self) { date in
                                            CircleProgress(getRingTuple(at: date)) {
                                                Text(appSetting.mainDate.dictKey == date.dictKey ? "✓" : String(date.day))
                                                    .foregroundColor(textColor(at: date))
                                                    .bodyText()
                                            }
                                        }
                                    }
                                    .padding(.bottom, 10)
                                }
                            }
                        } else {
                            if isEmojiView && !habitsWrapped.compactMap({$0}).isEmpty {
                                EmojiCalendarRow(week: selectedDate.weekNum(startFromMon: appSetting.isMondayStart),
                                                 isExpanded: isExpanded, selectedDate: $selectedDate, habit: habitsWrapped.compactMap({$0})[0])
                            } else {
                                HStack(spacing: 8) {
                                    ForEach(selectedDate.containedWeek(week:
                                                                        selectedDate.weekNum(startFromMon: appSetting.isMondayStart), from: appSetting.isMondayStart ? 2 : 1), id: \.self) { date in
                                        CircleProgress(getRingTuple(at: date)) {
                                            Text(appSetting.mainDate.dictKey == date.dictKey ? "✓" : String(date.day))
                                                .foregroundColor(textColor(at: date))
                                                .bodyText()
                                        }
                                    }
                                }
                                .padding(.bottom, 10)
                            }
                        }
                    }
                }
            }
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

struct CaptureCalendar_Previews: PreviewProvider {
    static var previews: some View {
        CaptureCalendar(showCalendarSelect: .constant(false),
                        isEmojiView: .constant(false), isExpanded: .constant(true),
                        selectedDate: .constant(Date()), habit1: HabitContext.sample1
        )
        .environmentObject(AppSetting())
        .rowBackground()
    }
}
