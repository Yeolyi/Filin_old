//
//  AddUnit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/15.
//

import SwiftUI

class AddUnit: ObservableObject {
    @AutoSave("addUnit", defaultValue: [:])
    var addUnit: [UUID: Int] {
        didSet {
            objectWillChange.send()
        }
    }
}
