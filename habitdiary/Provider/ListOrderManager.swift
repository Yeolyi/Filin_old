//
//  ListOrderManager.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/14.
//

import SwiftUI

class ListOrderManager: ObservableObject {
    @AutoSave("habitOrder", defaultValue: [])
    var habitOrder : [UUID] {
        didSet {
            objectWillChange.send()
        }
    }
}
