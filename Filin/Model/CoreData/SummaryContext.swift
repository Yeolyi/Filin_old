//
//  SummaryContext.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/09.
//

import SwiftUI
import CoreData

final class SummaryContext: ObservableObject, IDIdentifiable {
    
    let id: UUID
    @Published var name: String
    @Published var first: UUID?
    @Published var second: UUID?
    @Published var third: UUID?
    
    init(_ summary: Summary) {
        let habitManager = HabitContextManager.shared
        id = summary.id
        name = summary.name
        first = summary.first
        second = summary.second
        third = summary.third
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    func contains(id: UUID) -> Bool {
        id == first || id == second || id == third
    }
    
    func setByNumber(_ num: Int, habit: HabitContext?) {
        switch num {
        case 1: first = habit?.id
        case 2: second = habit?.id
        case 3: third = habit?.id
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
    var habitArray: [UUID?] {
        [first, second, third]
    }
    var isEmpty: Bool {
        habitArray.compactMap({$0}).isEmpty
    }
}

final class SummaryContextManager: ContextEditable, ObservableObject {
    
    typealias ObjectContext = SummaryContext
    typealias CoreDataType = Summary
    
    @Published var contents: [SummaryContext] = []
    
    private init() {
        contents = fetched.map{ SummaryContext.init($0) }
        if contents.isEmpty {
            contents.append(.init(id: UUID(), name: "Default"))
        }
    }

    static var shared = SummaryContextManager()
    
    func save() {
        for objectContext in contents {
            if let index = fetched.firstIndex(where: {$0.id == objectContext.id}) {
                let current = fetched[index]
                current.name = objectContext.name
                current.first = objectContext.first
                current.second = objectContext.second
                current.third = objectContext.third
            } else {
                let newHabit = Summary(context: context)
                newHabit.id = objectContext.id
                newHabit.name = objectContext.name
                newHabit.first = objectContext.first
                newHabit.second = objectContext.second
                newHabit.third = objectContext.third
            }
        }
        do {
            try context.save()
        } catch {
            assertionFailure("Habit 저장 실패")
        }
    }
    
    func addObject(_ object: ObjectContext) {
        contents.append(object)
    }
    
}
