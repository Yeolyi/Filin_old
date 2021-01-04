//
//  CalendarHabitWrapper.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

class CalendarHabitWrapper: ObservableObject {
    
    @Published var value: [Habit?] = []
    var habitNum: Int {
        value.compactMap({$0}).count
    }
    var compact: [Habit] {
        value.compactMap{$0}
    }
    
    init(habits: [Habit?]) {
        guard habits.count <= 3 else {
            assertionFailure()
            value.append(habits[0])
            value.append(habits[1])
            value.append(habits[2])
            return
        }
        self.value = habits
        while value.count != 3 {
            value.append(nil)
        }
    }
}
