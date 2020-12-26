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
    @EnvironmentObject var displayManager: DisplayManager
    let targetHabit: Habit
    
    @State var name: String
    @State var habitType: HabitCycleType
    @State var dayOfTheWeek: [Int]
    @State var numberOfTimes: String
    @State var colorHex: String
    @State var requiredSecond: String
    
    @State var isDeleteAlert = false
    @State var isRequiredTime = false
    
    init(targetHabit: Habit) {
        self.targetHabit = targetHabit
        self._name = State(initialValue: targetHabit.name)
        self._dayOfTheWeek = State(initialValue: targetHabit.dayOfWeek?.map {Int($0)} ?? [])
        self._numberOfTimes = State(initialValue: String(targetHabit.numberOfTimes))
        self._colorHex = State(initialValue: targetHabit.colorHex)
        self._requiredSecond = State(initialValue: String(targetHabit.requiredSecond))
        
        self._habitType = State(initialValue: targetHabit.cycleType)
        self._isRequiredTime = State(initialValue: targetHabit.requiredSecond != 0)
    }
    
    var isSaveAvailable: Bool {
        name != "" && !(habitType == .weekly && dayOfTheWeek.isEmpty) && Int(numberOfTimes) ?? 0 > 0
    }
    
    var body: some View {
        VStack {
            InlineNavigationBar(
                title: "\(targetHabit.name)",
                button1: {
                    saveButton
                }, button2: {
                    EmptyView()
                }
            )
            ScrollView {
                Group {
                    Text("Name".localized)
                        .sectionText()
                    TextFieldWithEndButton("Drink water".localized, text: $name)
                    Text("Cycle".localized)
                        .sectionText()
                    CheckPicker(options: [HabitCycleType.daily, HabitCycleType.weekly], selected: $habitType)
                        .padding(8)
                        .padding([.leading, .trailing], 10)
                    if habitType == .weekly { DayOfWeekSelector(dayOfTheWeek: $dayOfTheWeek) }
                }
                Text("Times".localized)
                    .sectionText()
                TextFieldWithEndButton("15", text: $numberOfTimes)
                    .keyboardType(.numberPad)
                Toggle("Required time", isOn: $isRequiredTime)
                    .sectionText()
                if isRequiredTime {
                    TextFieldWithEndButton("15", text: $requiredSecond)
                        .keyboardType(.numberPad)
                }
                Text("Color".localized)
                    .sectionText()
                ColorHorizontalPicker(selectedColor: $colorHex)
                deleteButton
            }
        }
    }
    var saveButton: some View {
        Button(action: {
            guard isSaveAvailable else { return }
            targetHabit.edit(
                name: name, colorHex: colorHex,
                dayOfWeek: habitType == .daily ? [] : dayOfTheWeek, numberOfTimes: numberOfTimes,
                requiredSecond: requiredSecond, managedObjectContext
            )
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save".localized)
                .headerButton()
        }
        .opacity(isSaveAvailable ? 1.0 : 0.5)
    }
    var deleteButton: some View {
        Button(action: { self.isDeleteAlert = true }) {
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
                if let index = displayManager.habitOrder.firstIndex(
                    where: {$0 == targetHabit.id}
                ) {
                    displayManager.habitOrder.remove(at: index)
                } else {
                    assertionFailure()
                }
                targetHabit.delete(managedObjectContext)
                presentationMode.wrappedValue.dismiss()
            }))
    }
}

struct EditHabit_Previews: PreviewProvider {
    static var previews: some View {
        let context = makeContext()
        EditHabit(targetHabit: Habit(context: context))
            .environment(\.managedObjectContext, context)
            .environmentObject(DisplayManager())
    }
}
