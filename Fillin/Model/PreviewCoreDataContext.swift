//
//  PreviewCoreDataContext.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI
import CoreData

func makeContext() -> NSManagedObjectContext{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    Habit.saveHabit(
        id: UUID(), name: "Preview", color: "#0F0F0F", dayOfWeek: [], numberOfTimes: "10",
        requiredSecond: "0", context
    )
    return context
}
