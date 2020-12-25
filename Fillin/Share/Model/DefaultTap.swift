//
//  DefaultTap.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/24.
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
