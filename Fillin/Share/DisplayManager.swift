//
//  ListOrderManager.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/14.
//

import SwiftUI

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
    @AutoSave("routineProfile", defaultValue: [])
    var routineProfile: [RoutineProfile] {
        didSet {
            objectWillChange.send()
        }
    }
}
