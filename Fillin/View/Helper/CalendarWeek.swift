//
//  CalendarWeek.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

struct CalendarWeek<Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme
    let dateList: [Date]
    let content: (Date) -> Content
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack {
            ForEach(dateList, id: \.self) { date in
                content(date)
            }
        }
    }
    
    init(week: Int, selectedDate: Binding<Date>, content: @escaping (Date) -> Content) {
        self._selectedDate = selectedDate
        self.content = content
        var tempDateList: [Date] = []
        let firstDayOfWeek = selectedDate.wrappedValue.firstDayOfWeek ?? 1
        for diff in 1 - firstDayOfWeek ..< 8 - firstDayOfWeek {
            let newDate = Calendar.current.date(
                byAdding: .day,
                value: diff + 7 * (week - 1),
                to: selectedDate.wrappedValue.firstDayOfMonth ?? Date()
            ) ?? Date()
            tempDateList.append(newDate)
        }
        dateList = tempDateList
    }
    
}

/*
struct CalendarWeek_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWeek()
    }
}
*/
