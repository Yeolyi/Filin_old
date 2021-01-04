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
    @ObservedObject var habit: Habit
    @State var activeSheet: DetailViewActiveSheet?
    @State var selectedDate = Date()

    init(habit: Habit) {
        self.habit = habit
        if !habit.isDaily {
            _selectedDate = State(initialValue: Date().nearDayOfWeekDate((habit.dayOfWeek).map {Int($0)}))
        }
    }
    var body: some View {
        if habit.isFault {
            EmptyView()
        } else {
            ScrollView {
                VStack(spacing: 0) {
                    RingCalendar(selectedDate: $selectedDate, habits: [habit, nil, nil])
                    TodayInformation(habit: habit, selectedDate: $selectedDate)
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
                    EditHabit(targetHabit: habit, increment: incrementPerTap)
                        .environment(\.managedObjectContext, managedObjectContext)
                        .environmentObject(listOrderManager)
                        .environmentObject(incrementPerTap)
                case .emoji:
                    EmojiListEdit()
                        .environmentObject(emojiManager)
                }
            }
        }
    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var listOrderManager: DisplayManager
    @EnvironmentObject var incrementPerTap: IncrementPerTap
    
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview()
        return HabitDetailView(habit: coreDataPreview.habit1)
            .environment(\.managedObjectContext, coreDataPreview.context)
            .environmentObject(coreDataPreview.displayManager)
            .environmentObject(coreDataPreview.incrementPerTap)
    }
}
