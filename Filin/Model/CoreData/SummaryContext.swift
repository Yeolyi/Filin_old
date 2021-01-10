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
    @Published var first: HabitContext?
    @Published var second: HabitContext?
    @Published var third: HabitContext?
    
    init(_ summary: Summary) {
        let habitManager = HabitContextManager.shared
        id = summary.id
        name = summary.name
        first = habitManager.contents.first(where: {$0.id == summary.first})
        self.second = habitManager.contents.first(where: {$0.id == summary.second})
        self.third = habitManager.contents.first(where: {$0.id == summary.second})
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    func contains(id: UUID) -> Bool {
        id == first?.id || id == second?.id || id == third?.id
    }
    
    func setByNumber(_ num: Int, habit: HabitContext?) {
        switch num {
        case 1: first = habit
        case 2: second = habit
        case 3: third = habit
        default:
            assertionFailure()
        }
    }
    func getByNumber(_ num: Int) -> HabitContext? {
        switch num {
        case 1: return first
        case 2: return second
        case 3: return third
        default:
            assertionFailure()
            return first
        }
    }
    var habitArray: [HabitContext?] {
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
    }
    
    static var shared = SummaryContextManager()
    
    func save() {
        for objectContext in contents {
            if let index = fetched.firstIndex(where: {$0.id == objectContext.id}) {
                let current = fetched[index]
                current.name = objectContext.name
                current.first = objectContext.first?.id
                current.second = objectContext.second?.id
                current.third = objectContext.third?.id
            } else {
                let newHabit = Summary(context: context)
                newHabit.id = objectContext.id
                newHabit.name = objectContext.name
                newHabit.first = objectContext.first?.id
                newHabit.second = objectContext.second?.id
                newHabit.third = objectContext.third?.id
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
