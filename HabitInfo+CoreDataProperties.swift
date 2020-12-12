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
    @NSManaged public var dayOfWeek: [Int16]?
    @NSManaged public var explanation: String?
    @NSManaged public var habitType: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var times: Int16
    @NSManaged public var userOrder: Int16
    @NSManaged public var diary: [String:String]
}

extension HabitInfo : Identifiable {

}
