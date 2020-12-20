//
//  AddHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct EditHabit: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var listOrderManager: ListOrderManager
    let targetHabit: HabitInfo
    @State var habitName = ""
    @State var habitType = HabitType.daily
    @State var dayOfTheWeek: [Int] = []
    @State var number = ""
    @State var selectedColor = ""
    @State var isDeleteAlert = false
    init(targetHabit: HabitInfo) {
        self.targetHabit = targetHabit
        self._habitName = State(initialValue: targetHabit.name)
        self._habitType = State(initialValue: HabitType(rawValue: targetHabit.habitType) ?? .daily)
        self._dayOfTheWeek = State(initialValue: targetHabit.targetDays?.map {Int($0)} ?? [])
        self._number = State(initialValue: String(targetHabit.targetAmount))
        self._selectedColor = State(initialValue: targetHabit.color)
    }
    var isSaveAvailable: Bool {
        habitName != "" && !(habitType == .weekly && dayOfTheWeek.isEmpty) && Int(number) ?? 0 > 0
    }
    func saveAndExit() {
        guard isSaveAvailable else { return }
        dayOfTheWeek = dayOfTheWeek.sorted(by: <)
        targetHabit.name = habitName
        targetHabit.color = selectedColor
        targetHabit.habitType = habitType.rawValue
        targetHabit.targetDays = dayOfTheWeek.map({Int16($0)})
        targetHabit.targetAmount = Int16(number) ?? 0
        CoreDataManager.save(managedObjectContext)
        self.presentationMode.wrappedValue.dismiss()
    }
    var body: some View {
        VStack {
            InlineNavigationBar(
                title: "\(targetHabit.name) 수정",
                button1: {
                    Button(action: saveAndExit) {
                        Text("저장")
                            .headerButton()
                    }
                    .opacity(isSaveAvailable ? 1.0 : 0.5)
                }, button2: {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("취소")
                            .headerButton()
                    }
                }
            )
            ScrollView {
                Text("이름")
                    .sectionText()
                TextField("물 다섯잔 마시기", text: $habitName)
                    .rowBackground()
                Text("주기")
                    .sectionText()
                CheckPicker(options: [HabitType.daily, HabitType.weekly], selected: $habitType)
                    .padding(8)
                    .padding([.leading, .trailing], 10)
                if habitType == .weekly { DayOfWeekSelector(dayOfTheWeek: $dayOfTheWeek) }
                Text("횟수")
                    .sectionText()
                TextField("15회", text: $number)
                    .keyboardType(.numberPad)
                    .rowBackground()
                Text("테마색")
                    .sectionText()
                ColorHorizontalPicker(selectedColor: $selectedColor)
                deleteButton
            }
        }
        .padding(.top, 40)
        .keyboardTouchAreaBackground()
    }
    var deleteButton: some View {
        Button(action: {
            self.isDeleteAlert = true
        }) {
            HStack {
                Spacer()
                Text("삭제")
                    .foregroundColor(.red)
                Spacer()
            }
            .padding(.top, 30)
            .padding(.bottom, 30)
        }
        .alert(isPresented: $isDeleteAlert) { deleteAlert }
    }
    var deleteAlert: Alert {
        Alert(
            title: Text("\(targetHabit.name)을 삭제하시겠습니까?"),
            message: nil,
            primaryButton: .default(Text("취소")),
            secondaryButton: .destructive(Text("삭제"), action: {
                if let index = listOrderManager.habitOrder.firstIndex(
                    where: {$0.elementId == targetHabit.id}
                ) {
                    listOrderManager.habitOrder.remove(at: index)
                }
                managedObjectContext.delete(targetHabit)
                CoreDataManager.save(managedObjectContext)
                presentationMode.wrappedValue.dismiss()
            }))
    }
}
/*
 struct EditHabit_Previews: PreviewProvider {
 static var previews: some View {
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 EditHabit(targetHabit: HabitInfo(context: context))
 .environment(\.managedObjectContext, context)
 .environmentObject(AppSetting())
 }
 }
 */
