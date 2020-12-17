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
        VStack {
            ZStack {
                Text("\(Date().month)월 \(Date().day)일 일기")
                    .font(.custom("NanumBarunpen", size: 40))
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("취소")
                            .font(.custom("NanumBarunpen", size: 20))
                            .padding(.leading, 20)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Button(action: {
                        habit.diary[targetDate.dictKey] = memo == "" ? nil : memo
                        saveContext()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("확인")
                            .font(.custom("NanumBarunpen", size: 20))
                            .padding(.trailing, 20)
                            .foregroundColor(.black)
                    }
                }
            }
            TextView(text: $memo)
                .rowBackground()
                .padding(10)
        }
        .padding(.top, 20)
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
