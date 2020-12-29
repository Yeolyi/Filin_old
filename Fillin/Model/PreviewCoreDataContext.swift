//
//  PreviewCoreDataContext.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI
import CoreData

func makeContext() -> NSManagedObjectContext {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    Habit.saveHabit(
        id: UUID(), name: "Preview", color: "#0F0F0F", dayOfWeek: [], numberOfTimes: "10",
        requiredSecond: 0, context
    )
    return context
}

func sampleHabit(name: String, dayOfWeek: [Int] = [1, 2, 3, 4, 5, 6, 7], seconds: Int = 0, count: Int = 10) -> Habit {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Habit", in: context)
    let habit = NSManagedObject.init(entity: entity!, insertInto: nil) as! Habit
    habit.id = UUID()
    habit.name = name
    var tempAchievement: [String: Int16] = [:]
    for diff in -6..<7 {
        let date = Date().addDate(-diff)!
        tempAchievement[date.dictKey] = Int16.random(in: 0...Int16(count))
    }
    habit.achievement = tempAchievement
    habit.colorHex = "#a5a5a5"
    habit.dayOfWeek = dayOfWeek.map {Int16($0)}
    habit.dailyEmoji = [:]
    habit.numberOfTimes = Int16(count)
    habit.requiredSecond = Int16(seconds)
    return habit
}

func sampleRoutine(name: String, dayOfTheWeek: [Int16], time: String) -> Routine {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Routine", in: context)
    let routine = NSManagedObject.init(entity: entity!, insertInto: nil) as! Routine
    routine.name = name
    routine.dayOfWeek = dayOfTheWeek
    routine.time = time
    routine.list = [UUID](repeating: UUID(), count: Int.random(in: 3...6))
    return routine
}
