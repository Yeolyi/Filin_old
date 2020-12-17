//
//  ListOrderManager.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/14.
//

import SwiftUI

struct OrderInfo: Codable, Hashable {
    var id: UUID
    var dayOfWeek: [Int]?
}

class ListOrderManager: ObservableObject {
    @AutoSave("habitOrder", defaultValue: [])
    var habitOrder : [OrderInfo] {
        didSet {
            objectWillChange.send()
        }
    }
}
