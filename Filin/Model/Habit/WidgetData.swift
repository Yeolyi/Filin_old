//
//  WidgetData.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/28.
//

import SwiftUI

struct WidgetHabitData: Codable {
    let id: UUID
    let name: String
    let numberOfTimes: Int
    let current: Int
}

class WidgetDataManager {
    @AutoSave("todayAchievements", defaultValue: [])
    static var todayAchievements: [WidgetHabitData]
}
