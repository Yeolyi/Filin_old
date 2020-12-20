//
//  HabitInfo+CoreDataProperties.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//
//

import SwiftUI
import CoreData

extension HabitInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitInfo> {
        return NSFetchRequest<HabitInfo>(entityName: "HabitInfo")
    }

    @NSManaged public var achieve: [String: Int16]
    @NSManaged public var color: String
    @NSManaged public var targetDays: [Int16]?
    @NSManaged public var habitType: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var targetAmount: Int16
    @NSManaged public var diary: [String: String]
    @NSManaged public var requiredSecond: Int16
    func isComplete(at date: Date) -> Bool {
        let currentAmount = achieve[date.dictKey] ?? 0
        return targetAmount <= currentAmount
    }
    func progress(at date: Date) -> Double {
        Double(achieve[date.dictKey] ?? 0)/Double(targetAmount)
    }
    var isTodayTodo: Bool {
        habitType == HabitType.daily.rawValue || targetDays?.contains(Int16(Date().dayOfTheWeek)) == true
    }
}

extension HabitInfo: Identifiable {

}
