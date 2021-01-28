//
//  HabitWidget.swift
//  HabitWidget
//
//  Created by SEONG YEOL YI on 2021/01/28.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    typealias ConfigurationIntent = SelectWidgetHabitIntent
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let intent = SelectWidgetHabitIntent()
        if !WidgetBridge.todayAchievements.isEmpty {
            let firstHabit = WidgetBridge.todayAchievements[0]
            let habitCompact = HabitCompact(identifier: firstHabit.id.uuidString, display: firstHabit.name)
            habitCompact.name = firstHabit.name
            intent.habit = habitCompact
        } else {
            let id = UUID()
            WidgetBridge.todayAchievements = [
                HabitWidgetData(
                    id: id, name: "Stretching".localized,
                    numberOfTimes: 10, current: 6, colorHex: ThemeColor.colorList[0].hex
                )
            ]
            let habitCompact = HabitCompact(identifier: id.uuidString, display: "Stretching".localized)
            intent.habit = habitCompact
        }
        let entry = SimpleEntry(date: Date(), configuration: intent)
        completion(entry)
    }
    
    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    typealias ConfigurationIntent = SelectWidgetHabitIntent
    let date: Date
    let configuration: ConfigurationIntent
}

@main
struct HabitWidget: Widget {
    let kind: String = "HabitWidget"
    typealias ConfigurationIntent = SelectWidgetHabitIntent
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            HabitWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Today's goal".localized)
        .description("Check the progress of the goal at a glance.")
    }
}
