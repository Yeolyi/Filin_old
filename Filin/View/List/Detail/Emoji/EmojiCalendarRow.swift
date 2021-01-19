//
//  EmojiCalendarRow.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct EmojiCalendarRow: View {
    let week: Int
    let isExpanded: Bool
    @ObservedObject var habit: HabitContext
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(selectedDate.containedWeek(week: week), id: \.self) { date in
                Button(action: { self.selectedDate = date }) {
                    VStack {
                        Text(String(date.day))
                            .foregroundColor(selectedDate.dictKey == date.dictKey ? habit.color : ThemeColor.mainColor(colorScheme))
                            .bodyText()
                        Text(habit.dailyEmoji[date.dictKey] ?? "")
                            .headline()
                            .frame(width: 40, height: 40)
                    }
                }
                .opacity(selectedDate.month == date.month ? 1 : 0.5)
            }
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    
}
/*
struct EmojiCalendarRow_Previews: PreviewProvider {
    static var previews: some View {
        EmojiCalendarRow()
    }
}
*/
