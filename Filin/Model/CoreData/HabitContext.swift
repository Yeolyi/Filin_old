//
//  HabitContext.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/09.
//

import SwiftUI
import CoreData

infix operator <<

class HabitContext: IDIdentifiable, Identifiable, ObservableObject, Hashable {
    
    static var sample1: HabitContext {
        let habit = HabitContext(name: "Stretching".localized, id: UUID(), numberOfTimes: 10, requiredSec: 10)
        var tempAchievement: [DateKey: Int] = [:]
        for i in -7...0 {
            tempAchievement[Date().addDate(i)!.dictKey] = Int.random(in: 0...10)
        }
        habit.achievement = tempAchievement
        return habit
    }
    
    static var sample2: HabitContext {
        let habit = HabitContext(name: "Drink water".localized, id: UUID(), numberOfTimes: 8, requiredSec: 0)
        var tempAchievement: [DateKey: Int] = [:]
        for i in -7...0 {
            tempAchievement[Date().addDate(i)!.dictKey] = Int.random(in: 0...8)
        }
        habit.achievement = tempAchievement
        return habit
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
    
    static func == (lhs: HabitContext, rhs: HabitContext) -> Bool {
        lhs.id == rhs.id
    }

    typealias DateKey = String
    
    let id: UUID
    @Published var addUnit = 1
    @Published var name: String
    @Published var dayOfWeek: [Int] = [1, 2, 3, 4, 5, 6, 7]
    @Published var color: Color = .blue
    @Published var achievement: [DateKey: Int] = [:]
    @Published var numberOfTimes: Int = 10
    @Published var dailyEmoji: [DateKey: String] = [:]
    @Published var requiredSec: Int = 0
    
    init(_ habit: Habit, addUnit: Int) {
        id = habit.id
        name = habit.name
        dayOfWeek = habit.dayOfWeek.map(Int.init)
        color = Color(hex: habit.colorHex)
        achievement = habit.achievement.mapValues(Int.init)
        numberOfTimes = Int(habit.numberOfTimes)
        dailyEmoji = habit.dailyEmoji
        requiredSec = Int(habit.requiredSecond)
        self.addUnit = addUnit
    }
    
    init(
        name: String, id: UUID = UUID(), dayOfWeek: [Int] = [1, 2, 3, 4, 5, 6, 7],
        color: Color = .gray, numberOfTimes: Int = 10, requiredSec: Int = 0
    ) {
        self.id = id
        self.name = name
        self.dayOfWeek = dayOfWeek
        self.color = color
        self.numberOfTimes = numberOfTimes
        self.requiredSec = requiredSec
    }
    
    var isTimer: Bool {
        requiredSec > 0
    }
    
    func calAchieve(at date: Date, isAdd: Bool) {
        achievement[date.dictKey] = (achievement[date.dictKey] ?? 0) + (isAdd ? addUnit : -addUnit)
    }
    
    func update(to habitContext: HabitContext) {
        self.name = habitContext.name
        self.dayOfWeek = habitContext.dayOfWeek
        self.color = habitContext.color
        self.numberOfTimes = habitContext.numberOfTimes
        self.requiredSec = habitContext.requiredSec
        self.addUnit = habitContext.addUnit
    }
    
    func isComplete(at date: Date) -> Bool {
        let currentAmount = achievement[date.dictKey] ?? 0
        return numberOfTimes <= currentAmount
    }
    func progress(at date: Date) -> Double? {
        guard let achievement = achievement[date.dictKey] else {
            return nil
        }
        return Double(achievement)/Double(numberOfTimes)
    }
    func isTodo(at dayOfWeekInt: Int) -> Bool {
        dayOfWeek.contains(dayOfWeekInt)
    }
    var isDaily: Bool {
        dayOfWeek.count == 7
    }
    
    static func << (lhs: Habit, rhs: HabitContext) {
        lhs.id = rhs.id
        lhs.achievement = rhs.achievement.mapValues(Int16.init)
        lhs.colorHex = rhs.color.hex
        lhs.dailyEmoji = rhs.dailyEmoji
        lhs.dayOfWeek = rhs.dayOfWeek.map(Int16.init)
        lhs.name = rhs.name
        lhs.numberOfTimes = Int16(rhs.numberOfTimes)
        lhs.requiredSecond = Int16(rhs.requiredSec)
    }
    
}

final class HabitContextManager: ObservableObject, ContextEditable {
    
    typealias CoreDataType = Habit
    typealias ObjectContext = HabitContext
    
    @Published var contents: [HabitContext] = []
    
    @AutoSave("addUnit", defaultValue: [:])
    var addUnit: [UUID: Int] {
        didSet {
            objectWillChange.send()
        }
    }
    
    private init() {
        contents = fetched.map { habit in
            HabitContext.init(habit, addUnit: addUnit.first(where: {(key, _) in key == habit.id})?.value ?? 1)
        }
    }
    
    static var shared = HabitContextManager()
    
    private var deleteID: [UUID] = []
    
    func save() {
        for objectContext in contents {
            addUnit[objectContext.id] = objectContext.addUnit
            if let index = fetched.firstIndex(where: {$0.id == objectContext.id}) {
                fetched[index] << objectContext
            } else {
                let newHabit = Habit(context: context)
                newHabit << objectContext
            }
        }
        do {
            try context.save()
        } catch {
            assertionFailure("Habit 저장 실패")
        }
        for id in deleteID {
            if let habit = fetched.first(where: {$0.id == id}) {
                context.delete(habit)
            }
        }
    }
    
    func deleteObject(id: UUID) {
        guard let index = contents.firstIndex(where: {$0.id == id}) else {
            assertionFailure("ID와 매칭되는 \(type(of: ObjectContext.self)) 인스턴스가 없습니다.")
            return
        }
        contents.remove(at: index)
        deleteID.append(id)
        let summaryContext = SummaryContextManager.shared.contents[0]
        if summaryContext.first == id {
            summaryContext.first = nil
            print("1")
        }
        if summaryContext.second == id {
            summaryContext.second = nil
            print("2")
        }
        if summaryContext.third == id {
            summaryContext.third = nil
            print("3")
        }
    }
    
    func addObject(_ object: HabitContext) {
        contents.append(object)
    }
}
