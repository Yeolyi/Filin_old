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
        case .daily: return "매일"
        case .weekly: return "매주"
        }
    }
    case daily = "매일"
    case weekly = "매주"
}
