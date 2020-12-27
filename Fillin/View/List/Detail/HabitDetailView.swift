//
//  Main.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

enum DetailViewActiveSheet: Identifiable {
    case diary, edit
    var id: UUID {
        UUID()
    }
}

struct HabitDetailView: View {
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
                VStack(spacing: 10) {
                    Text("Calendar".localized)
                        .sectionText()
                    CalendarRow(selectedDate: $selectedDate, habits: [habit])
                    Text("Data".localized)
                        .sectionText()
                    TodayInformation(habit: habit, selectedDate: $selectedDate)
                    Text("Note".localized)
                        .sectionText()
                    MemoRow(activeSheet: $activeSheet, habit: habit, selectedDate: selectedDate)
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
                case .diary:
                    MemoSheet(habit: habit, targetDate: selectedDate)
                        .allowAutoDismiss(false)
                case .edit:
                    EditHabit(targetHabit: habit)
                        .environment(\.managedObjectContext, managedObjectContext)
                        .environmentObject(listOrderManager)
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
