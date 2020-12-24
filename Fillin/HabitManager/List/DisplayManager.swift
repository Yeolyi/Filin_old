//
//  ListOrderManager.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/14.
//

import SwiftUI

struct SummaryProfile: Codable {
    var name: String = "기본"
    var first: UUID?
    var second: UUID?
    var third: UUID?
    func contains(id: UUID) -> Bool {
        id == first || id == second || id == third
    }
    mutating func setByNumber(_ num: Int, id: UUID?) {
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
}

class DisplayManager: ObservableObject {
    @AutoSave("habitOrder", defaultValue: [])
    var habitOrder: [UUID] {
        didSet {
            objectWillChange.send()
        }
    }
    @AutoSave("summaryProfile", defaultValue: [])
    var summaryProfile: [SummaryProfile] {
        didSet {
            objectWillChange.send()
        }
    }
}
