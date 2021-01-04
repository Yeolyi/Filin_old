//
//  PreviewCoreDataContext.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI
import CoreData

struct CoreDataPreview {
    
    var displayManager = DisplayManager()
    var incrementPerTap = IncrementPerTap()
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let id1 = UUID()
    let id2 = UUID()
    
    var habit1: Habit {
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let fetched = (try? context.fetch(fetchRequest)) ?? []
        return fetched[0]
    }
    
    init() {
        for entityName in ["Habit", "Summary", "Routine"] {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchRequest)
                for managedObject in results {
                    if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                        context.delete(managedObjectData)
                    }
                }
            } catch let error as NSError {
                print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
            }
        }
        displayManager.habitOrder = []
        addHabitToContext()
    }
    
    func addHabitToContext() {
        Habit.saveHabit(
            id: id1, name: "Preview1", color: "#b57ddf", dayOfWeek: [1, 2, 3, 4, 5, 6, 7], numberOfTimes: 15,
            requiredSecond: 0, context
        )
        Habit.saveHabit(
            id: id2, name: "Preview2", color: "#b57ddf", dayOfWeek: [1, 3, 5], numberOfTimes: 10,
            requiredSecond: 10, context
        )
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let fetched = (try? context.fetch(fetchRequest)) ?? []
        let habit1 = fetched[0]
        var tempAchievement: [String: Int16] = [:]
        for dateIndex in -40...0 {
            let movedDate = Date().addDate(dateIndex)!
            tempAchievement[movedDate.dictKey] = Int16.random(in: 0...habit1.numberOfTimes)
        }
        habit1.achievement = tempAchievement
        Summary.save(name: "Default", first: id1, second: id2, third: nil, managedObjectContext: context)
        displayManager.habitOrder.append(id1)
        displayManager.habitOrder.append(id2)
        Routine.save(name: "RoutinePreview", list: [id1, id2], time: "13-00", dayOfWeek: [1, 3, 5], context: context, completion: {_ in})
        incrementPerTap.addUnit[id1] = 1
        incrementPerTap.addUnit[id2] = 1
    }
    
    static func sampleHabit(name: String, dayOfWeek: [Int] = [1, 2, 3, 4, 5, 6, 7], seconds: Int = 0, count: Int = 10) -> Habit {
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
        routine.list = [id1, id2]
        return routine
    }
    
    static func sampleRoutine(name: String, dayOfTheWeek: [Int16], time: String) -> Routine {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Routine", in: context)
        let routine = NSManagedObject.init(entity: entity!, insertInto: nil) as! Routine
        routine.name = name
        routine.dayOfWeek = dayOfTheWeek
        routine.time = time
        routine.list = [UUID(), UUID(), UUID(), UUID(), UUID()]
        return routine
    }
    
    static func addSampleData(to context: NSManagedObjectContext, displayManager: DisplayManager) {
        let (id1, id2, id3, id4) = (UUID(), UUID(), UUID(), UUID())
        
        Habit.saveHabit(
            id: id1, name: "스트레칭", color: "#b57ddf",
            dayOfWeek: [1, 2, 3, 4, 5, 6, 7], numberOfTimes: 10, requiredSecond: 10, context
        )
        Habit.saveHabit(
            id: id2, name: "물 마시기", color: "#5996f8",
            dayOfWeek: [1, 2, 3, 4, 5, 6, 7], numberOfTimes: 8, requiredSecond: 0, context
        )
        Habit.saveHabit(
            id: id3, name: "산책", color: "#f07264",
            dayOfWeek: [1, 3, 5, 7], numberOfTimes: 3, requiredSecond: 0, context
        )
        Habit.saveHabit(
            id: id4, name: "비타민", color: "#f5ad60",
            dayOfWeek: [1, 3, 5], numberOfTimes: 3, requiredSecond: 0, context
        )
        
        Summary.save(name: "Default", first: id3, second: id1, third: id4, managedObjectContext: context)
        
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let fetched = (try? context.fetch(fetchRequest)) ?? []
        let habit1 = fetched[0]
        let habit2 = fetched[1]
        let habit3 = fetched[2]
        let habit4 = fetched[3]
        var tempAchievement: [String: Int16] = [:]
        for dateIndex in -40...0 {
            let movedDate = Date().addDate(dateIndex)!
            tempAchievement[movedDate.dictKey] = Int16.random(in: 0...habit1.numberOfTimes)
        }
        habit1.achievement = tempAchievement
        for dateIndex in -40...0 {
            let movedDate = Date().addDate(dateIndex)!
            tempAchievement[movedDate.dictKey] = Int16.random(in: 0...habit2.numberOfTimes)
        }
        habit2.achievement = tempAchievement
        for dateIndex in -40...0 {
            let movedDate = Date().addDate(dateIndex)!
            tempAchievement[movedDate.dictKey] = Int16.random(in: 0...habit3.numberOfTimes)
        }
        habit3.achievement = tempAchievement
        for dateIndex in -40...0 {
            let movedDate = Date().addDate(dateIndex)!
            tempAchievement[movedDate.dictKey] = Int16.random(in: 0...habit4.numberOfTimes)
        }
        habit4.achievement = tempAchievement
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
        displayManager.habitOrder = [id1, id2, id3, id4]
        
    }
    
}
