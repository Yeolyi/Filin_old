//
//  CalendarRow.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

/// - Note: AppSetting이 전달되어야함. 근데 왜 body 변수는 연산 프로퍼티일까?
struct CalendarInterface<Content: View>: View {
    
    @State var showCalendarSelect = false
    @State var isAnimation = false
    
    @Binding var selectedDate: Date
    @Binding var isExpanded: Bool
    @Binding var isEmojiView: Bool
    
    let content: (_ week: Int, _ isExpanded: Bool) -> Content
    let color: Color
    
    @EnvironmentObject var appSetting: AppSetting
    
    init(selectedDate: Binding<Date>, color: Color, isExpanded: Binding<Bool>, isEmojiView: Binding<Bool>,
         @ViewBuilder content: @escaping (_ week: Int, _ isExpanded: Bool) -> Content
    ) {
        self._selectedDate = selectedDate
        self._isExpanded = isExpanded
        self._isEmojiView = isEmojiView
        self.content = content
        self.color = color
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                if showCalendarSelect {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                } else {
                    HStack {
                        Group {
                            if isExpanded {
                                Text(selectedDate.localizedYearMonth)
                            } else {
                                Text(selectedDate.localizedMonthDay)
                            }
                        }
                        .foregroundColor(color)
                        .headline()
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    VStack(spacing: 0) {
                        HStack(spacing: 8) {
                            ForEach(
                                appSetting.isMondayStart ? [2, 3, 4, 5, 6, 7, 1] : [1, 2, 3, 4, 5, 6, 7],
                                id: \.self
                            ) { dayOfWeek in
                                Text(Date.dayOfTheWeekStr(dayOfWeek))
                                    .bodyText()
                                    .foregroundColor(.gray)
                                    .frame(width: 40)
                            }
                        }
                        .padding(.bottom, 8)
                        VStack {
                            if isExpanded {
                                ForEach(
                                    1..<selectedDate.weekNuminMonth(isMondayStart: appSetting.isMondayStart) + 1,
                                    id: \.self
                                ) { week in
                                    content(week, true)
                                }
                            } else {
                                content(selectedDate.weekNum(startFromMon: appSetting.isMondayStart), false)
                            }
                        }
                        BasicButton(isExpanded ? "chevron.compact.up" : "chevron.compact.down") {
                            withAnimation {
                                self.isExpanded.toggle()
                            }
                        }
                    }
                }
            }
            .rowBackground(innerBottomPadding: false)
            controller
        }
        .padding(.bottom, 5)
    }
    
    var controller: some View {
        HStack(spacing: 5) {
            Button(action: { withAnimation { isEmojiView.toggle() } }) {
                HStack {
                    Spacer()
                    BasicImage(imageName: isEmojiView ? "percent" : "face.smiling")
                    Text(isEmojiView ? "Show progress".localized : "Show Emoji".localized)
                        .bodyText()
                    Spacer()
                }
                .rowBackground(innerBottomPadding: true, 10, 0)
                .padding(.bottom, 3)
            }
            Button(action: { withAnimation { showCalendarSelect.toggle() } }) {
                HStack {
                    Spacer()
                    BasicImage(imageName: showCalendarSelect ? "checkmark" : "calendar")
                    Text(showCalendarSelect ? "Done" : "Select Date")
                        .bodyText()
                    Spacer()
                }
                .rowBackground(innerBottomPadding: true, 10, 0)
                .padding(.bottom, 3)
            }
        }
    }
}

struct CustomCalendar_Previews: PreviewProvider {
    static var previews: some View {
        RingCalendar(selectedDate: .constant(Date()), isExpanded: true, habit1: FlHabit.habit1)
            .environmentObject(AppSetting())
    }
}
