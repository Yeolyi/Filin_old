//
//  EditRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct EditRoutine: View {
    
    @ObservedObject var routine: Routine

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
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("\(routine.name)")
                            .headline()
                        Spacer()
                        HeaderText("Save".localized) {
                            routine.edit(
                                name: name, list: listData.sortedValue,
                                time: isReminderUsed ? reminderTime.hourAndMinuteStr : nil,
                                dayOfWeek: dayOfWeek,
                                context: context
                            ) { _ in }
                            presentationMode.wrappedValue.dismiss()
                        }
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
                        VStack(spacing: 15) {
                            HStack {
                                Text("List".localized)
                                    .bodyText()
                                Spacer()
                            }
                            NavigationLink(destination:
                                            RoutineSetList(listData: listData)
                                            .navigationBarTitle(Text(""), displayMode: .inline)
                            ) {
                                HStack {
                                    Text(String(format: NSLocalizedString("Consists of %d goals", comment: ""), routine.list.count))
                                        .bodyText()
                                    Spacer()
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .mainColor()
                            }
                        }
                        .rowBackground()
                        VStack {
                            HStack {
                                Text("Repeat")
                                    .bodyText()
                                Spacer()
                            }
                            DayOfWeekSelector(dayOfTheWeek: $dayOfWeek)
                        }
                        .rowPadding()
                        VStack {
                            HStack {
                                Text("Use reminder".localized)
                                    .bodyText()
                                Spacer()
                                if isReminderUsed {
                                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .accentColor(ThemeColor.mainColor(colorScheme))
                                }
                                PaperToggle($isReminderUsed)
                            }
                        }
                        .rowBackground()
                        Button(action: {self.isDeleteAlert = true}) {
                            Text("Delete".localized)
                                .foregroundColor(.red)
                                .bodyText()
                        }
                        .frame(minWidth: 44, minHeight: 22)
                        .alert(isPresented: $isDeleteAlert) { deleteAlert }
                        .padding(.vertical, 30)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
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
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
}

struct EditRoutine_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview()
        EditRoutine(routine: coreDataPreview.sampleRoutine(name: "Default", dayOfTheWeek: [1, 2, 3, 4], time: "12-03"))
            .environment(\.managedObjectContext, coreDataPreview.context)
            .environmentObject(coreDataPreview.displayManager)
    }
}
