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
    @NSManaged public var color: String
    @NSManaged public var dayOfWeek: [Int16]?
    @NSManaged public var type: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var timesToComplete: Int16
    @NSManaged public var memo: [String: String]
    @NSManaged public var requiredSecond: Int16
    func isComplete(at date: Date) -> Bool {
        let currentAmount = achievement[date.dictKey] ?? 0
        return timesToComplete <= currentAmount
    }
    func progress(at date: Date) -> Double {
        Double(achievement[date.dictKey] ?? 0)/Double(timesToComplete)
    }
    var isTodayTodo: Bool {
        type == HabitType.daily.rawValue || dayOfWeek?.contains(Int16(Date().dayOfTheWeek)) == true
    }
}

extension Habit: Identifiable {

}
