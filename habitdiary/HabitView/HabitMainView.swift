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
    
    @EnvironmentObject var sharedViewData: SharedViewData
    @ObservedObject var habit: HabitInfo
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var listOrderManager: ListOrderManager
    @State var activeSheet: ActiveSheet?
    @State var selectedDate = Date()
    
    init(habit: HabitInfo) {
        self.habit = habit
        if habit.habitType == HabitType.weekly.rawValue {
            var dateIterate = Date()
            guard let targetDays = habit.targetDays else {
                return
            }
            while !targetDays.contains(Int16(dateIterate.dayOfTheWeek)) {
                var dayComponent = DateComponents()
                dayComponent.day = 1
                let theCalendar = Calendar.current
                dateIterate = theCalendar.date(byAdding: dayComponent, to: dateIterate)!
            }
            _selectedDate = State(initialValue: dateIterate)
        }
    }
    
    var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    Text("달력")
                        .sectionText()
                    CalendarRow(selectedDate: $selectedDate, habit: habit)
                    .rowBackground()
                    .padding([.leading, .trailing], 10)
                    Text("기록")
                        .sectionText()
                    TodayHabit(habit: habit, selectedDate: $selectedDate)
                        .padding([.leading, .trailing], 10)
                        .padding(.bottom, 20)
                    Text("일기")
                        .sectionText()
                    DiaryRow(activeSheet: $activeSheet, habit: habit, selectedDate: selectedDate)
                        .padding([.leading, .trailing], 10)
                        .padding(.bottom, 60)
                }
            }
            .padding(.top, 1)
            .navigationBarTitle(habit.name)
            .navigationBarItems(
                trailing:
                    Button(action: { activeSheet = ActiveSheet.edit }) {
                        Text("편집")
                    }
            )
            .sheet(item: $activeSheet) { item in
                switch(item) {
                case .diary:
                    DiaryModal(habit: habit, targetDate: selectedDate)
                        .allowAutoDismiss(false)
                case .edit:
                    EditHabit(targetHabit: habit)
                        .environment(\.managedObjectContext, managedObjectContext)
                        .environmentObject(listOrderManager)
                }
            }
            .onAppear {
                withAnimation {
                    sharedViewData.inMainView = false
                }
            }
            .onDisappear {
                withAnimation {
                    sharedViewData.inMainView = true
                }
            }
    }
}


struct HabitViewMain_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return HabitViewMain(habit: .init(context: context))
            .environment(\.managedObjectContext, context)
    }
}

