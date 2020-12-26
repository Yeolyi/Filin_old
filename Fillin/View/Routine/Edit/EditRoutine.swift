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
    @State var name = ""
    @State var habitList: [UUID]
    @State var reminderTime: Date
    @State var isDeleteAlert = false
    @ObservedObject var listData: ListData<UUID>
    
    init(routine: Routine) {
        self.routine = routine
        _name = State(initialValue: routine.name)
        _habitList = State(initialValue: routine.list)
        _reminderTime = State(initialValue: Date(hourAndMinuteStr: routine.reminderTimes[0]))
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
                                reminderTimes: [reminderTime.hourAndMinuteStr], context: context
                            )
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
                    Text("Name".localized)
                        .sectionText()
                    TextFieldWithEndButton("Drink water".localized, text: $name)
                    Text("List".localized)
                        .sectionText()
                    NavigationLink(destination:
                                    RoutineSetList(listData: listData)
                    ) {
                        HStack {
                            Text("Change list")
                                .rowHeadline()
                            Spacer()
                        }
                        .rowBackground()
                    }
                    deleteButton
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
