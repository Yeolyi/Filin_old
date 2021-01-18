//
//  PreviewCoreDataContext.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI
import CoreData

class CoreDataPreview {
    
    var habitcontextManager = HabitContextManager.shared
    var summaryManager = SummaryContextManager.shared
    var routineManager = RoutineContextManager.shared
    
    let id1 = UUID()
    let id2 = UUID()
    let id3 = UUID()
    let id4 = UUID()
    
    private init() {
        let habit1 = HabitContext(name: "Stretching".localized, id: id1, color: Color(hex: "#b57ddf"), numberOfTimes: 10, requiredSec: 10)
        let habit2 = HabitContext(name: "Drink water".localized, id: id2, color: Color(hex: "#5996f8"), numberOfTimes: 8, requiredSec: 0)
        let habit3 = HabitContext(name: "A ten-minute walk".localized, id: id3, dayOfWeek: [1, 3, 5, 7], color: Color(hex: "#f07264"), numberOfTimes: 3, requiredSec: 0)
        let habit4 = HabitContext(name: "Vitamins".localized, id: id4, dayOfWeek: [1, 3, 5], color: Color(hex: "#f5ad60"), numberOfTimes: 3, requiredSec: 0)
        for habit in [habit1, habit2, habit3, habit4] {
            var tempAchievement: [String: Int] = [:]
            for i in -60...0 {
                tempAchievement[Date().addDate(i)!.dictKey] = Int.random(in: 0...habit.numberOfTimes)
            }
            habit.achievement = tempAchievement
            habitcontextManager.addObject(habit)
        }
        summaryManager.addObject(.init(id: UUID(), name: "Default"))
        summaryManager.contents[0].first = id1
        summaryManager.contents[0].second = id2
        let routine1 = RoutineContext(UUID(), name: "After wake up".localized)
        routine1.list = [habit1, habit2]
        let routine2 = RoutineContext(UUID(), name: "Before bed".localized)
        routine2.list = [habit1, habit2, habit1, habit1]
        routineManager.addObject(routine1)
        routineManager.addObject(routine2)
    }
    
    static let shared = CoreDataPreview()

}
