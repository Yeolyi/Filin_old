//
//  Routine+CoreDataProperties.swift
//  
//
//  Created by SEONG YEOL YI on 2020/12/26.
//
//

import Foundation
import CoreData

extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var id: UUID
    @NSManaged public var list: [UUID]
    @NSManaged public var name: String
    @NSManaged public var time: String?
    @NSManaged public var dayOfWeek: [Int16]
    
    static func save(
        name: String, list: [UUID], time: String?, dayOfWeek: [Int],
        context: NSManagedObjectContext, completion: @escaping (Bool) -> Void
    ) {
        let newRoutine = Routine(context: context)
        let id = UUID()
        newRoutine.id = id
        newRoutine.name = name
        newRoutine.list = list
        newRoutine.dayOfWeek = dayOfWeek.map(Int16.init)
        newRoutine.time = time
        if let time = time {
            RoutineNotiManager.add(id: id, name: name, date: Date(hourAndMinuteStr: time), dayOfWeek: dayOfWeek) { isSuccess in
                completion(isSuccess)
            }
        }
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    func edit(name: String, list: [UUID], time: String?, dayOfWeek: [Int], context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        self.name = name
        self.list = list
        self.dayOfWeek = dayOfWeek.map(Int16.init)
        self.time = time
        RoutineNotiManager.delete(id: self.id)
        if let time = time {
            RoutineNotiManager.add(id: id, name: name, date: Date(hourAndMinuteStr: time), dayOfWeek: dayOfWeek) { isSuccess in
                completion(isSuccess)
            }
        }
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    func delete(_ context: NSManagedObjectContext) {
        context.delete(self)
        do {
            try context.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}
