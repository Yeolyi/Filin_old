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

    @NSManaged public var achieve: [String:Int16]
    @NSManaged public var color: String
    @NSManaged public var targetDays: [Int16]?
    @NSManaged public var habitType: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var targetAmount: Int16
    @NSManaged public var diary: [String:String]
    @NSManaged public var requiredSecond: Int16
}

extension HabitInfo : Identifiable {

}
