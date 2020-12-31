//
//  EditRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct EditRoutine: View {
    
    @ObservedObject var routine: Routine
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State var name = ""
    @State var habitList: [UUID]
    @State var isReminderUsed: Bool
    @State var reminderTime: Date
    @State var isDeleteAlert = false
    @State var dayOfWeek: [Int]
    @ObservedObject var listData: ListData<UUID>
    
    init(routine: Routine) {
        self.routine = routine
        _name = State(initialValue: routine.name)
        _habitList = State(initialValue: routine.list)
        _dayOfWeek = State(initialValue: routine.dayOfWeek.map(Int.init))
        if let time = routine.time {
            _isReminderUsed = State(initialValue: true)
            _reminderTime = State(initialValue: Date(hourAndMinuteStr: time))
        } else {
            _isReminderUsed = State(initialValue: true)
            _reminderTime = State(initialValue: Date())
        }
        listData = ListData<UUID>(values: routine.list, save: {_ in})
    }
    
    var body: some View {
        NavigationView {
            VStack {
                InlineNavigationBar(
                    title: "\(routine.name)",
                    button1: {
                        Button(action: {
                            routine.edit(
                                name: name, list: listData.sortedValue,
                                time: isReminderUsed ? reminderTime.hourAndMinuteStr : nil,
                                dayOfWeek: dayOfWeek,
                                context: context
                            ) { _ in
                                
                            }
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save".localized)
                                .headerButton()
                        }
                    }, button2: {
                        EmptyView()
                    }
                )
                ScrollView {
                    VStack(spacing: 35) {
                        HStack {
                            Text("Name".localized)
                                .headline()
                                .padding(.leading, 18)
                            TextFieldWithEndButton("Drink water".localized, text: $name)
                        }
                        NavigationLink(destination: RoutineSetList(listData: listData)) {
                            HStack {
                                Text("Change habit list")
                                    .headline()
                                Spacer()
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .mainColor()
                        }
                        .rowBackground()
                        VStack {
                            HStack {
                                Text("Repeat")
                                    .headline()
                                    .padding(.leading, 18)
                                Spacer()
                            }
                            DayOfWeekSelector(dayOfTheWeek: $dayOfWeek)
                                .rowBackground()
                        }
                        VStack {
                            Toggle("", isOn: $isReminderUsed)
                                .toggleStyle(
                                    ColoredToggleStyle(
                                        label: "Use reminder".localized,
                                        onColor: ThemeColor.mainColor(colorScheme)
                                    )
                                )
                                .padding(.horizontal, 18)
                            if isReminderUsed {
                                HStack {
                                    Text("Reminder time".localized)
                                        .bodyText()
                                        .padding(.leading, 10)
                                    Spacer()
                                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .accentColor(ThemeColor.mainColor(colorScheme))
                                }
                                .rowBackground()
                            }
                        }
                        deleteButton
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
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
            title: Text(String(format: NSLocalizedString("Delete %@?", comment: ""), routine.name)),
            message: nil,
            primaryButton: .default(Text("Cancel".localized)),
            secondaryButton: .destructive(Text("Delete".localized), action: {
                routine.delete(context)
                presentationMode.wrappedValue.dismiss()
            }))
    }
}

/*
 struct EditRoutine_Previews: PreviewProvider {
 static var previews: some View {
 EditRoutine()
 }
 }
 */
