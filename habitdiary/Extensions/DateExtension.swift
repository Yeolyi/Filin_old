//
//  DateProvider.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import Foundation

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    var dayOfTheWeek: Int {
        Calendar.current.component(.weekday, from: self)
    }
    var weekNum: Int {
        Calendar.current.component(.weekOfMonth, from: self)
    }
    var monthLength: Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    var weekInMonth: Int? {
        let calendar = Calendar.current
        let weekRange = calendar.range(
            of: .weekOfMonth,
            in: .month,
            for: self
        )
        return weekRange?.count
    }
    var firstDayOfWeek: Int? {
        let calendar = Calendar.current
        var dateComponents  = calendar.dateComponents([.year, .month], from: self)
        dateComponents.day = 1
        return calendar.date(from: dateComponents)?.dayOfTheWeek
    }
    var lastDayOfWeek: Int? {
        let calendar = Calendar.current
        var dateComponents  = calendar.dateComponents([.year, .month], from: self)
        dateComponents.day = calendar.range(of: .day, in: .month, for: self)?.count
        return calendar.date(from: dateComponents)?.dayOfTheWeek
    }
    var firstDayOfMonth: Date? {
        var components = Calendar.current.dateComponents([.year, .month], from: self)
        components.day = 1
        return Calendar.current.date(from: components)
    }
    static func dayOfTheWeekStr(_ num: Int) -> String {
        var dateCursor = Date()
        let currentDayOfWeek = dateCursor.dayOfTheWeek
        dateCursor = dateCursor.addDate(num-currentDayOfWeek)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: dateCursor)
    }
    var dictKey: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    func addDate(_ num: Int) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = num
        let calendar = Calendar.current
        return calendar.date(byAdding: dayComponent, to: self)
    }
    func nearDayOfWeekDate(_ dayOfWeeks: [Int]) -> Date {
        var dateIterate = self
        while !dayOfWeeks.contains(dateIterate.dayOfTheWeek) {
            var dayComponent = DateComponents()
            dayComponent.day = 1
            let theCalendar = Calendar.current
            dateIterate = theCalendar.date(byAdding: dayComponent, to: dateIterate)!
        }
        return dateIterate
    }
    var localizedYearMonth: String {
        let df = DateFormatter()
        let userFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMM", options: 0, locale: Locale.current) ?? "yyyyMMM"
        df.setLocalizedDateFormatFromTemplate(userFormat)
        return df.string(from: self)
    }
    var localizedMonthDay: String {
        let df = DateFormatter()
        let userFormat = DateFormatter.dateFormat(fromTemplate: "MMMd", options: 0, locale: Locale.current) ?? "MMMd"
        df.setLocalizedDateFormatFromTemplate(userFormat)
        return df.string(from: self)
    }
}
