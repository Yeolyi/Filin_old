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
    
    static func dayOfTheWeekStr(_ num: Int) -> String {
        switch(num) {
        case 1:
            return "일"
        case 2:
            return "월"
        case 3:
            return "화"
        case 4:
            return "수"
        case 5:
            return "목"
        case 6:
            return "금"
        case 7:
            return "토"
        default:
            return ""
        }
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
        return calendar.date(byAdding: dayComponent, to: Date())
    }
    
}
