//
//  HabitInfo+CoreDataProperties.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//
//

import SwiftUI
import CoreData

extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var achievement: [String: Int16]
    @NSManaged public var colorHex: String
    @NSManaged public var dayOfWeek: [Int16]?
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var numberOfTimes: Int16
    @NSManaged public var memo: [String: String]
    @NSManaged public var requiredSecond: Int16
    func isComplete(at date: Date) -> Bool {
        let currentAmount = achievement[date.dictKey] ?? 0
        return numberOfTimes <= currentAmount
    }
    func progress(at date: Date) -> Double? {
        guard let achievement = achievement[date.dictKey] else {
            return nil
        }
        return Double(achievement)/Double(numberOfTimes)
    }
    var isTodayTodo: Bool {
        cycleType == .daily || dayOfWeek?.contains(Int16(Date().dayOfTheWeek)) == true
    }
    var cycleType: HabitCycleType {
        dayOfWeek == nil ? .daily : .weekly
    }
    var color: Color {
        Color(hex: colorHex)
    }
    func edit(
        name: String, colorHex: String,
        dayOfWeek: [Int], numberOfTimes: String,
        requiredSecond: String,
        _ managedObjectContext: NSManagedObjectContext
    ) {
        self.name = name
        self.colorHex = colorHex
        let dayOfWeekConverted = dayOfWeek.map({Int16($0)}).sorted()
        if dayOfWeekConverted.isEmpty {
            self.dayOfWeek = nil
        } else {
            self.dayOfWeek = dayOfWeekConverted
        }
        self.numberOfTimes = Int16(numberOfTimes) ?? 0
        self.requiredSecond = Int16(requiredSecond) ?? 0
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    static func saveHabit(id: UUID,
        name: String, color: String,
        dayOfWeek: [Int], numberOfTimes: String,
        requiredSecond: String,
        _ managedObjectContext: NSManagedObjectContext
    ) {
        let newHabit = Habit(context: managedObjectContext)
        newHabit.name = name
        newHabit.colorHex = color
        let dayOfWeekConverted = dayOfWeek.map({Int16($0)}).sorted()
        if dayOfWeekConverted.isEmpty {
            newHabit.dayOfWeek = nil
        } else {
            newHabit.dayOfWeek = dayOfWeekConverted
        }
        newHabit.id = id
        newHabit.numberOfTimes = Int16(numberOfTimes) ?? 0
        newHabit.achievement = [:]
        newHabit.requiredSecond = Int16(requiredSecond) ?? 0
        newHabit.memo = [:]
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    static func coreDataSave(_ managedObjectContext: NSManagedObjectContext) {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    func coreDataSave(_ managedObjectContext: NSManagedObjectContext) {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    func delete(_ managedObjectContext: NSManagedObjectContext) {
        managedObjectContext.delete(self)
        Habit.coreDataSave(managedObjectContext)
    }
}

extension Habit: Identifiable {

}
