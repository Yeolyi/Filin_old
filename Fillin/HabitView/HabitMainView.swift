//
//  Main.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case diary, edit
    var id: Int {
        hashValue
    }
}

struct HabitViewMain: View {
    @ObservedObject var habit: Habit
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var listOrderManager: DisplayManager
    @State var activeSheet: ActiveSheet?
    @State var selectedDate = Date()
    init(habit: Habit) {
        self.habit = habit
        if habit.type == HabitType.weekly.rawValue {
            _selectedDate = State(initialValue: Date().nearDayOfWeekDate((habit.dayOfWeek ?? []).map {Int($0)}))
        }
    }
    var body: some View {
            ScrollView {
                VStack(spacing: 10) {
                    Text("Calendar".localized)
                        .sectionText()
                    CalendarRow(selectedDate: $selectedDate, habits: [habit])
                    Text("Data".localized)
                        .sectionText()
                    TodayHabit(habit: habit, selectedDate: $selectedDate)
                    Text("Note".localized)
                        .sectionText()
                    DiaryRow(activeSheet: $activeSheet, habit: habit, selectedDate: selectedDate)
                }
            }
            .padding(.top, 1)
            .navigationBarTitle(habit.name)
            .navigationBarItems(
                trailing:
                    Button(action: { activeSheet = ActiveSheet.edit }) {
                        Text("Edit".localized)
                    }
            )
            .sheet(item: $activeSheet) { item in
                switch item {
                case .diary:
                    DiaryModal(habit: habit, targetDate: selectedDate)
                        .allowAutoDismiss(false)
                case .edit:
                    EditHabit(targetHabit: habit)
                        .environment(\.managedObjectContext, managedObjectContext)
                        .environmentObject(listOrderManager)
                }
            }
    }
}

/*
struct HabitViewMain_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return HabitViewMain(habit: .init(context: context))
            .environment(\.managedObjectContext, context)
    }
}
*/
