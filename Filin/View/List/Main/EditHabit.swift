//
//  AddHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct EditHabit: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var tempHabit: HabitContext
    let targetHabit: HabitContext
    @State var showTimes = false
    @State var isDeleteAlert = false
    
    @State var _isRequiredTime = false
    var isRequiredTime: Binding<Bool> {
        Binding(get: {_isRequiredTime}, set: {
            _isRequiredTime = $0
            if $0 == false {
                tempHabit.requiredSec = 0
            }
        })
    }
    @State var _minute: Int
    var minute: Binding<Int> {
        Binding(get: {_minute},
        set: {
            _minute = $0
            tempHabit.requiredSec = $0 * 60 + _second
        })
    }
    @State var _second: Int
    var second: Binding<Int> {
        Binding(get: {_second},
        set: {
            _second = $0
            tempHabit.requiredSec = $0 * _minute * 60
        })
    }
    
    @State var _isSet = false
    var isSet: Binding<Bool> {
        Binding(get: { _isSet}, set: {
            _isSet = $0
            if $0 {
                tempHabit.addUnit = tempHabit.numberOfTimes
                _setNum = 1
            } else {
                tempHabit.addUnit = 1
            }
        })
    }

    @State var _setNum = 1
    var setNum: Binding<Int> {
        Binding(get: { _setNum }, set: {
            _setNum = $0
            tempHabit.numberOfTimes = $0 * tempHabit.addUnit
        })
    }
    
    var oneTapNum: Binding<Int> {
        Binding(get: {tempHabit.addUnit}, set: {
            tempHabit.addUnit = $0
            tempHabit.numberOfTimes = _setNum * $0
        })
    }
    
    var isSaveAvailable: Bool {
        tempHabit.name != "" && !tempHabit.dayOfWeek.isEmpty && tempHabit.numberOfTimes > 0
    }
    
    init(targetHabit: HabitContext) {
        self.targetHabit = targetHabit
        tempHabit = HabitContext(name: "Temp")
        __setNum = State(initialValue: targetHabit.addUnit != 1 ? targetHabit.numberOfTimes / targetHabit.addUnit : 1)
        __minute = State(initialValue: targetHabit.requiredSec/60)
        __second = State(initialValue: targetHabit.requiredSec%60)
        __isRequiredTime = State(initialValue: targetHabit.requiredSec != 0)
        __isSet = State(initialValue: targetHabit.addUnit != 1)
        tempHabit.update(to: targetHabit)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text("\(tempHabit.name)")
                        .headline()
                    Spacer()
                    saveButton
                }
                .padding(20)
                Divider()
            }
            ScrollView {
                VStack(spacing: 8) {
                    VStack {
                        HStack {
                            Text("Name".localized)
                                .bodyText()
                            Spacer()
                        }
                        TextFieldWithEndButton("Drink water".localized, text: $tempHabit.name)
                    }
                    .rowBackground()
                    VStack {
                        HStack {
                            Text("Times".localized)
                                .bodyText()
                            Spacer()
                            BasicImage(imageName: showTimes ? "chevron.up" : "chevron.down")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                showTimes.toggle()
                            }
                        }
                        if showTimes {
                            HStack {
                                Text("Split into sets".localized)
                                    .bodyText()
                                Spacer()
                                PaperToggle(isSet)
                            }
                            if !isSet.wrappedValue {
                                PickerWithButton(str: "".localized, size: 100, number: $tempHabit.numberOfTimes)
                            } else {
                                PickerWithButton(str: "Number of times per set".localized, size: 100, number: oneTapNum)
                                PickerWithButton(str: "Number of sets".localized, size: 30, number: setNum)
                            }
                        }
                    }
                    .rowBackground()
                    VStack {
                        HStack {
                            Text("Timer".localized)
                                .bodyText()
                            Spacer()
                            PaperToggle(isRequiredTime)
                        }
                        if isRequiredTime.wrappedValue {
                            TimerPicker(minute: minute, second: second)
                        }
                    }
                    .rowBackground()
                    VStack {
                        HStack {
                            Text("Repeat".localized)
                                .bodyText()
                            Spacer()
                        }
                        DayOfWeekSelector(dayOfTheWeek: $tempHabit.dayOfWeek)
                    }
                    .rowPadding()
                    VStack {
                        HStack {
                            Text("Color".localized)
                                .bodyText()
                            Spacer()
                        }
                        ColorHorizontalPicker(selectedColor: $tempHabit.color)
                    }
                    .rowPadding()
                    .padding(.bottom, 30)
                    Divider()
                    deleteButton
                }
            }
        }
    }
    var saveButton: some View {
        HeaderText("Save".localized) {
            guard isSaveAvailable else { return }
            targetHabit.update(to: tempHabit)
            self.presentationMode.wrappedValue.dismiss()
        }
        .opacity(isSaveAvailable ? 1.0 : 0.5)
    }
    var deleteButton: some View {
        Button(action: { self.isDeleteAlert = true }) {
            Text("Delete".localized)
                .foregroundColor(.red)
                .bodyText()
                .padding(.vertical, 30)
        }
        .alert(isPresented: $isDeleteAlert) { deleteAlert }
    }
    var deleteAlert: Alert {
        Alert(
            title: Text(String(format: NSLocalizedString("Delete %@?", comment: ""), tempHabit.name)),
            message: nil,
            primaryButton: .default(Text("Cancel".localized)),
            secondaryButton: .destructive(Text("Delete".localized), action: {
                for profile in SummaryContextManager.shared.contents {
                    if let index = profile.habitArray.firstIndex(where: {$0?.id == tempHabit.id}) {
                        profile.setByNumber(index + 1, habit: nil)
                    }
                }
                HabitContextManager.shared.deleteObject(id: targetHabit.id)
                self.presentationMode.wrappedValue.dismiss()
            })
        )
    }
}

struct EditHabit_Previews: PreviewProvider {
    static var previews: some View {
        EditHabit(targetHabit: HabitContext(name: "Asd"))
    }
}
