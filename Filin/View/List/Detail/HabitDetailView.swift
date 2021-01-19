//
//  Main.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

enum DetailViewActiveSheet: Identifiable {
    case edit, emoji
    var id: UUID {
        UUID()
    }
}

struct HabitDetailView: View {
    
    @ObservedObject var emojiManager = EmojiManager()
    @EnvironmentObject var habit: HabitContext
    @EnvironmentObject var habitManager: HabitContextManager
    @EnvironmentObject var appSetting: AppSetting
    @State var activeSheet: DetailViewActiveSheet?
    @State var selectedDate = Date()
    
    init(habit: HabitContext) {
        if !habit.isDaily {
            _selectedDate = State(initialValue: Date().nearDayOfWeekDate((habit.dayOfWeek).map {Int($0)}))
        }
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                RingCalendar(selectedDate: $selectedDate, habit: habit)
                TodayInformation(selectedDate: $selectedDate)
                EmojiPicker(selectedDate: $selectedDate, habit: habit, emojiManager: emojiManager, activeSheet: $activeSheet)
                Text("")
                    .font(.system(size: 30))
            }
        }
        .padding(.top, 1)
        .navigationBarTitle(habit.name)
        .navigationBarItems(
            trailing:
                HeaderText("Edit".localized) {
                    activeSheet = DetailViewActiveSheet.edit
                }
        )
        .sheet(item: $activeSheet) { item in
            switch item {
            case .edit:
                EditHabit(targetHabit: habit)
                    .environmentObject(habitManager)
            case .emoji:
                EmojiListEdit()
                    .environmentObject(emojiManager)
            }
        }
        .onAppear {
            selectedDate = appSetting.mainDate
        }
    }
}
