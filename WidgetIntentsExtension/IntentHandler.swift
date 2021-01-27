//
//  IntentHandler.swift
//  WidgetIntentsExtension
//
//  Created by SEONG YEOL YI on 2021/01/28.
//

import Intents

class IntentHandler: INExtension, SelectHabitIntentHandling {
    
    @AutoSave("todayAchievements", defaultValue: [])
    var todayAchievements: [WidgetHabitData]
    
    func provideHabitOptionsCollection(
        for intent: SelectHabitIntent,
        with completion: @escaping (INObjectCollection<WidgetHabit>?, Error?) -> Void
    ) {
        print("테스트")
        let widgetHabitNames: [WidgetHabit] = todayAchievements.map(\.name).map { habitName in
            let widgetHabitName = WidgetHabit(
                identifier: UUID().uuidString, display: habitName
            )
            widgetHabitName.name = habitName
            return widgetHabitName
        }
        let collection = INObjectCollection(items: widgetHabitNames)
        completion(collection, nil)
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
