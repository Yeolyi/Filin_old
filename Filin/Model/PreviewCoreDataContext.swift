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
    
    private init() {
        habitcontextManager.addObject(.init(name: "Test1", id: id1))
        habitcontextManager.addObject(.init(name: "Test2", id: id2))
        summaryManager.addObject(.init(id: UUID(), name: "Default"))
        summaryManager.contents[0].first = habitcontextManager.contents[0]
        summaryManager.contents[0].second = habitcontextManager.contents[1]
        let newRoutine = RoutineContext(UUID(), name: "")
        newRoutine.list = [id1, id2]
        routineManager.addObject(newRoutine)
    }
    
    static let shared = CoreDataPreview()

}
