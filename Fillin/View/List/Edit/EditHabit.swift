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
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var displayManager: DisplayManager
    @ObservedObject var targetHabit: Habit
    
    @State var name: String
    @State var dayOfTheWeek: [Int]
    @State var numberOfTimes: String
    @State var colorHex: String
    @State var minute: Int
    @State var second: Int
    
    @State var isDeleteAlert = false
    @State var isRequiredTime = false
    
    init(targetHabit: Habit) {
        self.targetHabit = targetHabit
        self._name = State(initialValue: targetHabit.name)
        self._dayOfTheWeek = State(initialValue: targetHabit.dayOfWeek.map {Int($0)})
        self._numberOfTimes = State(initialValue: String(targetHabit.numberOfTimes))
        self._colorHex = State(initialValue: targetHabit.colorHex)
        self._minute = State(initialValue: Int(targetHabit.requiredSecond)/60)
        self._second = State(initialValue: Int(targetHabit.requiredSecond)%60)
        self._isRequiredTime = State(initialValue: targetHabit.requiredSecond != 0)
    }
    
    var isSaveAvailable: Bool {
        name != "" && !dayOfTheWeek.isEmpty && Int(numberOfTimes) ?? 0 > 0
    }
    
    var body: some View {
        if targetHabit.isFault {
            EmptyView()
        } else {
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
                    VStack(spacing: 35) {
                        HStack {
                            Text("Name".localized)
                                .rowHeadline()
                                .padding(.leading, 10)
                            TextFieldWithEndButton("Drink water".localized, text: $name)
                        }
                        HStack {
                            Text("Times".localized)
                                .rowHeadline()
                                .padding(.leading, 10)
                            TextFieldWithEndButton("15", text: $numberOfTimes)
                                .keyboardType(.numberPad)
                        }
                        VStack {
                            Toggle("", isOn: $isRequiredTime)
                                .toggleStyle(
                                    ColoredToggleStyle(
                                        label: "Timer".localized,
                                        onColor: ThemeColor.mainColor(colorScheme)
                                    )
                                )
                                .padding(.horizontal, 10)
                                .if(!isRequiredTime) {
                                    $0.padding(.bottom, 20)
                                }
                            if isRequiredTime {
                                GeometryReader { geo in
                                    HStack {
                                        VStack {
                                            Picker(selection: $minute, label: EmptyView(), content: {
                                                ForEach(0...59, id: \.self) { minute in
                                                    Text(String(minute))
                                                        .rowHeadline()
                                                }
                                            })
                                            .frame(height: 170)
                                            .frame(maxWidth: geo.size.width/2 - 10)
                                            .clipped()
                                            Text("Minute")
                                                .rowSubheadline()
                                        }
                                        VStack {
                                            Picker(selection: $second, label: EmptyView(), content: {
                                                ForEach(0...59, id: \.self) { second in
                                                    Text(String(second))
                                                        .rowHeadline()
                                                }
                                            })
                                            .frame(height: 170)
                                            .frame(maxWidth: geo.size.width/2 - 10)
                                            .clipped()
                                            Text("Second")
                                                .rowSubheadline()
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                }
                                .frame(height: 200)
                            }
                            VStack {
                                HStack {
                                    Text("Repeat".localized)
                                        .rowHeadline()
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                                DayOfWeekSelector(dayOfTheWeek: $dayOfTheWeek)
                                    .rowBackground()
                            }
                            VStack {
                                HStack {
                                    Text("Color".localized)
                                        .rowHeadline()
                                    Spacer()
                                }
                                .padding(.horizontal, 10)
                                ColorHorizontalPicker(selectedColor: $colorHex)
                                    .rowBackground()
                            }
                            deleteButton
                        }
                        .padding(.top, 10)
                    }
                }
            }
        }
    }
    var saveButton: some View {
        Button(action: {
            guard isSaveAvailable else { return }
            targetHabit.edit(
                name: name, colorHex: colorHex,
                dayOfWeek: dayOfTheWeek, numberOfTimes: numberOfTimes,
                requiredSecond: isRequiredTime ? minute * 60 + second : 0, managedObjectContext
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
                managedObjectContext.delete(targetHabit)
                do {
                    self.presentationMode.wrappedValue.dismiss()
                } catch {
                    print(error)
                }
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
