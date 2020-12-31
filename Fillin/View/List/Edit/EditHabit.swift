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
            VStack(spacing: 0) {
                InlineNavigationBar(
                    title: "\(targetHabit.name)",
                    button1: {
                        saveButton
                    }, button2: {
                        EmptyView()
                    }
                )
                ScrollView {
                    VStack(spacing: 8) {
                        VStack {
                            HStack {
                                Text("Name".localized)
                                    .bodyText()
                                Spacer()
                            }
                            TextFieldWithEndButton("Drink water".localized, text: $name)
                        }
                        .rowBackground()
                        VStack {
                            HStack {
                                Text("Times".localized)
                                    .bodyText()
                                Spacer()
                            }
                            TextFieldWithEndButton("15", text: $numberOfTimes)
                                .keyboardType(.numberPad)
                        }
                        .rowBackground()
                        VStack {
                            Toggle("", isOn: $isRequiredTime)
                                .toggleStyle(
                                    ColoredToggleStyle(
                                        label: "Timer".localized,
                                        onColor: ThemeColor.mainColor(colorScheme)
                                    )
                                )
                            if isRequiredTime {
                                GeometryReader { geo in
                                    HStack {
                                        VStack {
                                            Picker(selection: $minute, label: EmptyView(), content: {
                                                ForEach(0...500, id: \.self) { minute in
                                                    Text(String(minute))
                                                        .bodyText()
                                                }
                                            })
                                            .frame(height: 170)
                                            .frame(maxWidth: geo.size.width/2 - 10)
                                            .clipped()
                                            Text("Minute")
                                                .bodyText()
                                        }
                                        VStack {
                                            Picker(selection: $second, label: EmptyView(), content: {
                                                ForEach(0...59, id: \.self) { second in
                                                    Text(String(second))
                                                        .bodyText()
                                                }
                                            })
                                            .frame(height: 170)
                                            .frame(maxWidth: geo.size.width/2 - 10)
                                            .clipped()
                                            Text("Second")
                                                .bodyText()
                                        }
                                    }
                                }
                                .frame(height: 200)
                            }
                        }
                        .rowBackground()
                        VStack {
                            HStack {
                                Text("Repeat".localized)
                                    .bodyText()
                                Spacer()
                            }
                            DayOfWeekSelector(dayOfTheWeek: $dayOfTheWeek)
                        }
                        .rowBackground()
                        VStack {
                            HStack {
                                Text("Color".localized)
                                    .bodyText()
                                Spacer()
                            }
                            ColorHorizontalPicker(selectedColor: $colorHex)
                        }
                        .rowBackground()
                        deleteButton
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
                .font(.system(size: 18, weight: .semibold))
                .mainColor()
        }
        .frame(width: 44, height: 44)
        .padding(.trailing, 20)
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
