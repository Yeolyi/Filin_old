//
//  Summary+CoreDataProperties.swift
//  
//
//  Created by SEONG YEOL YI on 2020/12/26.
//
//

import Foundation
import CoreData


extension Summary {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Summary> {
        return NSFetchRequest<Summary>(entityName: "Summary")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var first: UUID?
    @NSManaged public var second: UUID?
    @NSManaged public var third: UUID?
    
    func contains(id: UUID) -> Bool {
        id == first || id == second || id == third
    }
    func setByNumber(_ num: Int, id: UUID?) {
        switch num {
        case 1: first = id
        case 2: second = id
        case 3: third = id
        default:
            assertionFailure()
        }
    }
    func getByNumber(_ num: Int) -> UUID? {
        switch num {
        case 1: return first
        case 2: return second
        case 3: return third
        default:
            assertionFailure()
            return first
        }
    }
    var idArray: [UUID?] {
        [first, second, third]
    }
    var isEmpty: Bool {
        idArray.compactMap({$0}).isEmpty
    }
    static func save(
        name: String,
        first: UUID?, second: UUID?, third: UUID?,
        managedObjectContext: NSManagedObjectContext
    ) {
        let newSummary = Summary(context: managedObjectContext)
        newSummary.id = UUID()
        newSummary.name = name
        newSummary.first = first
        newSummary.second = second
        newSummary.third = third
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    func edit(first: UUID?, second: UUID?, third: UUID?, managedObjectContext: NSManagedObjectContext) {
        self.first = first
        self.second = second
        self.third = third
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}
