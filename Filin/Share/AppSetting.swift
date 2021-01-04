//
//  SharedViewDagta.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

class AppSetting: ObservableObject {
    
    @AutoSave("runCount", defaultValue: 0)
    var runCount: Int
    @AutoSave("defaultTap", defaultValue: 0)
    var defaultTap: Int {
        didSet {
            objectWillChange.send()
        }
    }
    var isFirstRun: Bool {
        runCount == 1
    }
}
