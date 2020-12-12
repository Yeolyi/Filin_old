//
//  MemoModal.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct DiaryModal: View {
    
    @State var memo = ""
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
        NavigationView {
            TextView(text: $memo)
            .navigationBarTitle("오늘의 일기", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("취소")
                    }
                ,trailing:
                    Button(action: {
                        habit.diary[targetDate.dictKey] = memo == "" ? nil : memo
                        saveContext()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("확인")
                    }
            )
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

struct MemoModal_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return DiaryModal(habit: .init(context: context), targetDate: Date())
            .environment(\.managedObjectContext, context)
    }
}
