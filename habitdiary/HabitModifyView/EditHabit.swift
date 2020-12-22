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
    @EnvironmentObject var listOrderManager: DisplayManager
    let targetHabit: Habit
    @State var habitName = ""
    @State var habitType = HabitType.daily
    @State var dayOfTheWeek: [Int] = []
    @State var number = ""
    @State var selectedColor = ""
    @State var isDeleteAlert = false
    init(targetHabit: Habit) {
        self.targetHabit = targetHabit
        self._habitName = State(initialValue: targetHabit.name)
        self._habitType = State(initialValue: HabitType(rawValue: targetHabit.type) ?? .daily)
        self._dayOfTheWeek = State(initialValue: targetHabit.dayOfWeek?.map {Int($0)} ?? [])
        self._number = State(initialValue: String(targetHabit.timesToComplete))
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
        targetHabit.type = habitType.rawValue
        targetHabit.dayOfWeek = dayOfTheWeek.map({Int16($0)})
        targetHabit.timesToComplete = Int16(number) ?? 0
        CoreDataManager.save(managedObjectContext)
        self.presentationMode.wrappedValue.dismiss()
    }
    var body: some View {
        VStack {
            InlineNavigationBar(
                title: "\(targetHabit.name)",
                button1: {
                    Button(action: saveAndExit) {
                        Text("Save".localized)
                            .headerButton()
                    }
                    .opacity(isSaveAvailable ? 1.0 : 0.5)
                }, button2: {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel".localized)
                            .headerButton()
                    }
                }
            )
            ScrollView {
                Text("Name".localized)
                    .sectionText()
                TextFieldWithEndButton("Drink water".localized, text: $habitName)
                Text("Cycle".localized)
                    .sectionText()
                CheckPicker(options: [HabitType.daily, HabitType.weekly], selected: $habitType)
                    .padding(8)
                    .padding([.leading, .trailing], 10)
                if habitType == .weekly { DayOfWeekSelector(dayOfTheWeek: $dayOfTheWeek) }
                Text("Times".localized)
                    .sectionText()
                TextFieldWithEndButton("15", text: $number)
                    .keyboardType(.numberPad)
                Text("Color".localized)
                    .sectionText()
                ColorHorizontalPicker(selectedColor: $selectedColor)
                deleteButton
            }
        }
    }
    var deleteButton: some View {
        Button(action: {
            self.isDeleteAlert = true
        }) {
            HStack {
                Spacer()
                Text("Delete".localized)
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
            title: Text(String(format: NSLocalizedString("Delete %@?", comment: ""), targetHabit.name)),
            message: nil,
            primaryButton: .default(Text("Cancel".localized)),
            secondaryButton: .destructive(Text("Delete".localized), action: {
                if let index = listOrderManager.habitOrder.firstIndex(
                    where: {$0 == targetHabit.id}
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
