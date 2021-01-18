//
//  CalendarRow.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

struct CalendarInterface<Content: View>: View {
    
    @Binding var selectedDate: Date
    @Binding var isExpanded: Bool
    @Binding var isEmojiView: Bool
    @Environment(\.colorScheme) var colorScheme
    let content: (_ week: Int, _ isExpanded: Bool) -> Content
    let move: (Bool) -> Date
    let color: Color
    @State var lastDragPosition: DragGesture.Value?
    @State var isAnimation = false
    
    func gesture() -> some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged { value in
                self.lastDragPosition = value
            }
            .onEnded { value in
                let timeDiff = value.time.timeIntervalSince(lastDragPosition?.time ?? Date())
                let speed: CGFloat = CGFloat(value.translation.height - (lastDragPosition?.translation.height ?? 0)) / CGFloat(timeDiff)
                if abs(speed) > 50 && abs(value.translation.height/value.translation.width) < 1 {
                    if value.translation.width < 0 {
                        withAnimation {
                            selectedDate = move(true)
                        }
                    } else if value.translation.width > 0 {
                        withAnimation {
                            selectedDate = move(false)
                        }
                    }
                }
            }
    }
    
    init(selectedDate: Binding<Date>, color: Color, isExpanded: Binding<Bool>, isEmojiView: Binding<Bool>, move: @escaping (Bool) -> Date,
        content: @escaping (_ week: Int, _ isExpanded: Bool) -> Content
    ) {
        self._selectedDate = selectedDate
        self._isExpanded = isExpanded
        self._isEmojiView = isEmojiView
        self.content = content
        self.move = move
        self.color = color
    }
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack {
                    HStack {
                        Group {
                            if isExpanded {
                                Text(selectedDate.localizedYearMonthDay)
                            } else {
                                Text(selectedDate.localizedMonthDay)
                            }
                        }
                        .foregroundColor(color)
                        .headline()
                        Spacer()
                    }
                }
                Spacer()
                BasicButton(isEmojiView ? "face.smiling.fill" : "face.smiling") {
                    withAnimation {
                        isEmojiView.toggle()
                    }
                }
            }
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(1...7, id: \.self) { dayOfWeek in
                        Text(Date.dayOfTheWeekStr(dayOfWeek))
                            .bodyText()
                            .foregroundColor(.gray)
                            .frame(width: 40)
                    }
                }
                .padding(.bottom, 8)
                VStack {
                    if isExpanded {
                        ForEach(1..<(selectedDate.weekInMonth ?? 2) + 1, id: \.self) { week in
                            content(week, true)
                        }
                    } else {
                        content(selectedDate.weekNum, false)
                    }
                }
                BasicButton(isExpanded ? "chevron.compact.up" : "chevron.compact.down") {
                    withAnimation {
                        self.isExpanded.toggle()
                    }
                }
            }
        }
        .rowBackground(false)
        .highPriorityGesture(gesture())
    }
}

/*
 struct CustomCalendar_Previews: PreviewProvider {
 static var previews: some View {
 CalendarRow(selectedDate: .constant(Date()), habit: , isExpanded: true)
 }
 }
 */
