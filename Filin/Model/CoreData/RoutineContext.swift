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
    
    static var sample1: RoutineContext {
        let sample = RoutineContext(UUID(), name: "After wake up".localized)
        sample.list = [HabitContext.sample1, HabitContext.sample2, HabitContext.sample2, HabitContext.sample1, HabitContext.sample2]
        return sample
    }
    
    static var sample2: RoutineContext {
        let sample = RoutineContext(UUID(), name: "Before bed".localized)
        sample.list = [HabitContext.sample1, HabitContext.sample2, HabitContext.sample2, HabitContext.sample2]
        return sample
    }
    
    let id: UUID
    @Published var name: String
    @Published var list: [HabitContext] = []
    @Published var time: Date?
    @Published var dayOfWeek: [Int] = [1, 2, 3, 4, 5, 6, 7]
    
    init() {
        self.id = UUID()
        self.name = ""
    }
    
    init(_ routine: Routine) {
        id = routine.id
        name = routine.name
        list = routine.list.compactMap { id in
            HabitContextManager.shared.contents.first(where: {$0.id == id})
        }
        if let timeStr = routine.time {
            time = Date(hourAndMinuteStr: timeStr)
        }
        dayOfWeek = routine.dayOfWeek.map(Int.init)
    }
    init(_ id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    init(copy: RoutineContext) {
        id = UUID()
        name = copy.name
        list = copy.list
        time = copy.time
        dayOfWeek = copy.dayOfWeek
    }
    
    
    func update(to routine: RoutineContext) {
        name = routine.name
        list = routine.list
        time = routine.time
        dayOfWeek = routine.dayOfWeek
        deleteNoti()
        addNoti(completion: {_ in})
    }
}

class RoutineContextManager: ObservableObject, ContextEditable {
    
    typealias ObjectContext = RoutineContext
    typealias CoreDataType = Routine
    
    @Published var contents: [RoutineContext] = []
    
    private init() {
        contents = fetched.map({RoutineContext($0)})
    }
    
    static var shared = RoutineContextManager()
    
    func addObject(_ object: ObjectContext) {
        contents.append(object)
        object.addNoti { _ in }
    }
    
    private var deleteID: [UUID] = []
    
    func deleteObject(id: UUID) {
        guard let index = contents.firstIndex(where: {$0.id == id}) else {
            assertionFailure("ID와 매칭되는 \(type(of: ObjectContext.self)) 인스턴스가 없습니다.")
            return
        }
        contents[index].deleteNoti()
        contents.remove(at: index)
        deleteID.append(id)
        for id in deleteID {
            if let habit = fetched.first(where: {$0.id == id}) {
                context.delete(habit)
            }
        }
    }
    
    func save() {
        for objectContext in contents {
            if let index = fetched.firstIndex(where: {$0.id == objectContext.id}) {
                let current = fetched[index]
                current.name = objectContext.name
                current.list = objectContext.list.map(\.id)
                current.time = objectContext.time?.hourAndMinuteStr
                current.dayOfWeek = objectContext.dayOfWeek.map(Int16.init)
            } else {
                let newHabit = Routine(context: context)
                newHabit.id = objectContext.id
                newHabit.name = objectContext.name
                newHabit.list = objectContext.list.map(\.id)
                newHabit.time = objectContext.time?.hourAndMinuteStr
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
