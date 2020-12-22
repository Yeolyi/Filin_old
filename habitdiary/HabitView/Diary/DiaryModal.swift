//
//  MemoModal.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct DiaryModal: View {
    @State var memo = ""
    let habit: Habit
    let targetDate: Date
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    init(habit: Habit, targetDate: Date) {
        self.habit = habit
        self.targetDate = targetDate
        self._memo = State(initialValue: habit.memo[targetDate.dictKey] ?? "")
    }
    var body: some View {
        VStack {
            InlineNavigationBar(
                title: Date().localizedMonthDay,
                button1: {
                    Button(action: {
                        habit.memo[targetDate.dictKey] = memo == "" ? nil : memo
                        saveContext()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save".localized)
                            .headerButton()
                    }
                }, button2: {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel".localized)
                            .headerButton()
                    }
                }
            )
            TextView(text: $memo)
                .rowBackground()
        }
    }
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

/*
 struct MemoModal_Previews: PreviewProvider {
 static var previews: some View {
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 return DiaryModal(habit: .init(context: context), targetDate: Date())
 .environment(\.managedObjectContext, context)
 }
 }
 */
