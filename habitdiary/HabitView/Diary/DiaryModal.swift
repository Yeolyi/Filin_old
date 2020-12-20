//
//  MemoModal.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct DiaryModal: View {
    @State var memo = "탭하여 쓰기"
    let habit: HabitInfo
    let targetDate: Date
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    init(habit: HabitInfo, targetDate: Date) {
        self.habit = habit
        self.targetDate = targetDate
        self._memo = State(initialValue: habit.diary[targetDate.dictKey] ?? "")
    }
    var body: some View {
        VStack {
            InlineNavigationBar(
                title: "\(Date().month)월 \(Date().day)일 일기",
                button1: {
                    Button(action: {
                        habit.diary[targetDate.dictKey] = memo == "" ? nil : memo
                        saveContext()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("저장")
                            .headerButton()
                    }
                }, button2: {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("취소")
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
