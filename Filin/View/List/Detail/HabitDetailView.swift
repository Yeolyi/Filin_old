//
//  Main.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

enum DetailViewActiveSheet: Identifiable {
    case edit, emoji, share
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
                RingCalendar(selectedDate: $selectedDate, habit1: habit)
                TodayInformation(selectedDate: $selectedDate)
                EmojiPicker(selectedDate: $selectedDate, habit: habit, emojiManager: emojiManager, activeSheet: $activeSheet)
                Text("")
                    .font(.system(size: 30))
            }
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .edit:
                EditHabit(targetHabit: habit)
                    .environmentObject(habitManager)
            case .emoji:
                EmojiListEdit()
                    .environmentObject(emojiManager)
            case .share:
                HabitShare(habit: habit)
            }
        }
        .padding(.top, 1)
        .navigationBarTitle(habit.name)
        .navigationBarItems(
            trailing:
                HStack {
                    HeaderButton("square.and.arrow.up") {
                        activeSheet = DetailViewActiveSheet.share
                    }
                    HeaderText("Edit".localized) {
                        activeSheet = DetailViewActiveSheet.edit
                    }
                }
        )
        .onAppear {
            selectedDate = appSetting.mainDate
        }
    }
}
