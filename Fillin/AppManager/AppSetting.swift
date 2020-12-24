//
//  SharedViewDagta.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

enum DefaultTap: Int, PickerUsable, CaseIterable {
    var string: String {
        switch self {
        case .list: return "List".localized
        case .summary: return "Summary".localized
        case .routine: return "Routine".localized
        case .setting: return "Setting".localized
        }
    }
    case list = 0
    case summary = 1
    case routine = 2
    case setting = 3
}

class AppSetting: ObservableObject {
    @AutoSave("runCount", defaultValue: 0)
    var runCount: Int {
        didSet {
            objectWillChange.send()
        }
    }
    var isFirstRun: Bool {
        runCount == 1
    }
    @AutoSave("defaultTap", defaultValue: 0)
    var defaultTap: Int {
        didSet {
            objectWillChange.send()
        }
    }
}
