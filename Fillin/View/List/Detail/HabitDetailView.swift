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
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var listOrderManager: DisplayManager
    @State var activeSheet: DetailViewActiveSheet?
    @State var selectedDate = Date()

    init(habit: Habit) {
        self.habit = habit
        if habit.cycleType == HabitCycleType.weekly {
            _selectedDate = State(initialValue: Date().nearDayOfWeekDate((habit.dayOfWeek).map {Int($0)}))
        }
    }
    var body: some View {
        if habit.isFault {
            EmptyView()
        } else {
            ScrollView {
                VStack(spacing: 0) {
                    HabitCalendar(selectedDate: $selectedDate, habit: habit)
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
                    Button(action: { activeSheet = DetailViewActiveSheet.edit }) {
                        Text("Edit".localized)
                    }
            )
            .sheet(item: $activeSheet) { item in
                switch item {
                case .edit:
                    EditHabit(targetHabit: habit)
                        .environment(\.managedObjectContext, managedObjectContext)
                        .environmentObject(listOrderManager)
                case .emoji:
                    EmojiListEdit()
                        .environmentObject(emojiManager)
                }
            }
        }
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = makeContext()
        return HabitDetailView(habit: .init(context: context))
            .environment(\.managedObjectContext, context)
    }
}
