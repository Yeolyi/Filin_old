//
//  RoutineContext.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/09.
//

import SwiftUI
import CoreData

class RoutineContext: ObservableObject, IDIdentifiable, Hashable, Identifiable {
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
    
    static func == (lhs: RoutineContext, rhs: RoutineContext) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    var name: String
    var list: [UUID] = []
    var time: String?
    var dayOfWeek: [Int] = [1, 2, 3, 4, 5, 6, 7]
    
    init(_ routine: Routine) {
        id = routine.id
        name = routine.name
        list = routine.list
        time = routine.time
        dayOfWeek = routine.dayOfWeek.map(Int.init)
    }
    init(_ id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

class RoutineContextManager: ObservableObject, ContextEditable {
    
    typealias ObjectContext = RoutineContext
    typealias CoreDataType = Routine
    
    @Published var contents: [RoutineContext] = []
    
    private init() {
        contents = fetched.map{RoutineContext($0)}
    }
    
    static var shared = RoutineContextManager()
    
    func save() {
        for objectContext in contents {
            if let index = fetched.firstIndex(where: {$0.id == objectContext.id}) {
                let current = fetched[index]
                current.name = objectContext.name
                current.list = objectContext.list
                current.time = objectContext.time
                current.dayOfWeek = objectContext.dayOfWeek.map(Int16.init)
            } else {
                let newHabit = Routine(context: context)
                newHabit.id = objectContext.id
                newHabit.name = objectContext.name
                newHabit.list = objectContext.list
                newHabit.time = objectContext.time
                newHabit.dayOfWeek = objectContext.dayOfWeek.map(Int16.init)
            }
        }
        do {
            try context.save()
        } catch {
            assertionFailure("Habit 저장 실패")
        }
    }
}
