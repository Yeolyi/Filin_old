//
//  SampleHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI
import CoreData

enum HabitType: String, PickerUsable {
    var string: String {
        switch self {
        case .daily: return "Every day".localized
        case .weekly: return "Every week".localized
        }
    }
    case daily = "매일"
    case weekly = "매주"
}
