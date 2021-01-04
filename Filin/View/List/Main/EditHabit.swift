//
//  AddHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct EditHabit: View {

    @ObservedObject var targetHabit: Habit
    
    @State var name: String
    @State var dayOfTheWeek: [Int]
    @State var numberOfTimes: Int
    @State var colorHex: String
    @State var minute: Int
    @State var second: Int
    
    @State var isDeleteAlert = false
    @State var isRequiredTime = false
    
    @State var oneTapUnit = 1
    @State var isSet = false
    @State var setNum = 1
    
    @State var showTimes = false
    
    var setNumWrapper: Binding<Int> {
        Binding(get: { setNum }, set: { setNum = $0; numberOfTimes = setNum * oneTapUnit})
    }
    var oneTapWrapper: Binding<Int> {
        Binding(get: { oneTapUnit }, set: {oneTapUnit = $0; numberOfTimes = setNum * oneTapUnit})
    }
    var isSetWrapper: Binding<Bool> {
        Binding(
            get: { isSet },
            set: {
                if $0 {
                    oneTapUnit = numberOfTimes
                    setNum = 1
                } else {
                    numberOfTimes = oneTapUnit * setNum
                }
                isSet = $0
            }
        )
    }
    
    var isSaveAvailable: Bool {
        name != "" && !dayOfTheWeek.isEmpty && numberOfTimes > 0
    }
    
    var body: some View {
        if targetHabit.isFault {
            EmptyView()
        } else {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("\(targetHabit.name)")
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
                            TextFieldWithEndButton("Drink water".localized, text: $name)
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
                                    PaperToggle(isSetWrapper)
                                }
                                if !isSet {
                                    PickerWithButton(str: "".localized, size: 100, number: $numberOfTimes)
                                } else {
                                    PickerWithButton(str: "Number of times per set".localized, size: 100, number: oneTapWrapper)
                                    PickerWithButton(str: "Number of sets".localized, size: 30, number: setNumWrapper)
                                }
                            }
                        }
                        .rowBackground()
                        VStack {
                            HStack {
                                Text("Timer".localized)
                                    .bodyText()
                                Spacer()
                                PaperToggle($isRequiredTime)
                            }
                            if isRequiredTime {
                               TimerPicker(minute: $minute, second: $second)
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
                        .rowPadding()
                        VStack {
                            HStack {
                                Text("Color".localized)
                                    .bodyText()
                                Spacer()
                            }
                            ColorHorizontalPicker(selectedColor: $colorHex)
                        }
                        .rowPadding()
                        .padding(.bottom, 30)
                        Divider()
                        deleteButton
                    }
                }
            }
        }
    }
    var saveButton: some View {
        HeaderText("Save".localized) {
            guard isSaveAvailable else { return }
            targetHabit.edit(
                name: name, colorHex: colorHex,
                dayOfWeek: dayOfTheWeek, numberOfTimes: numberOfTimes,
                requiredSecond: isRequiredTime ? minute * 60 + second : 0, managedObjectContext
            )
            if let id = targetHabit.id {
                if isSet {
                    incrementPerTap.addUnit[id] = oneTapUnit
                } else {
                    incrementPerTap.addUnit[id] = 1
                }
            }
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
                for profile in summaryProfile {
                    if let index = profile.idArray.firstIndex(where: {$0 == targetHabit.id}) {
                        profile.setByNumber(index + 1, id: nil)
                    }
                }
                managedObjectContext.delete(targetHabit)
                self.presentationMode.wrappedValue.dismiss()
            })
        )
    }
    
    @FetchRequest(
        entity: Summary.entity(),
        sortDescriptors: []
    )
    var summaryProfile: FetchedResults<Summary>
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var displayManager: DisplayManager
    @EnvironmentObject var incrementPerTap: IncrementPerTap
    
    init(targetHabit: Habit, increment: IncrementPerTap) {
        self.targetHabit = targetHabit
        self._name = State(initialValue: targetHabit.name)
        self._dayOfTheWeek = State(initialValue: targetHabit.dayOfWeek.map {Int($0)})
        self._numberOfTimes = State(initialValue: Int(targetHabit.numberOfTimes))
        self._colorHex = State(initialValue: targetHabit.colorHex)
        self._minute = State(initialValue: Int(targetHabit.requiredSecond)/60)
        self._second = State(initialValue: Int(targetHabit.requiredSecond)%60)
        self._isRequiredTime = State(initialValue: targetHabit.requiredSecond != 0)
        if let id = targetHabit.id {
            _oneTapUnit = State(initialValue: increment.addUnit[id] ?? 1)
            _isSet = State(initialValue: !(increment.addUnit[id] == 1 || increment.addUnit[id] == nil))
            _setNum = State(initialValue: numberOfTimes/oneTapUnit)
        }
    }
    
}

struct EditHabit_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview()
        EditHabit(targetHabit: coreDataPreview.habit1, increment: coreDataPreview.incrementPerTap)
            .environment(\.managedObjectContext, coreDataPreview.context)
            .environmentObject(coreDataPreview.incrementPerTap)
    }
}
