//
//  RoutineMainView.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

enum RoutineSheet: Identifiable {
    case add
    case edit(Routine)
    var id: Int {
        switch self {
        case .add:
            return 0
        case .edit:
            return 1
        }
    }
}

struct RoutineView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var displayManager: DisplayManager
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Routine.entity(), sortDescriptors: [])
    var routines: FetchedResults<Routine>
    
    @State var isAddSheet: RoutineSheet?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if !routines.isEmpty {
                        Text("List".localized)
                            .sectionText()
                        VStack(spacing: 0) {
                            ForEach(routines, id: \.self) { routine in
                                RoutineRow(routine: routine, isSheet: $isAddSheet)
                            }
                        }
                    } else {
                        ForEach([
                            sampleRoutine(name: "After wake up".localized, dayOfTheWeek: [], time: "07-00"),
                            sampleRoutine(name: "Before bed".localized, dayOfTheWeek: [], time: "23-30")
                        ], id: \.self) { routine in
                            RoutineRow(routine: routine, isSheet: $isAddSheet)
                        }
                        .opacity(0.5)
                        .disabled(true)
                        Text("Group and repeat goals to make them a habit.".localized)
                            .rowHeadline()
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        ListEmptyButton(action: {
                            isAddSheet = .add
                        }, str: "Add routine".localized)
                        .padding(.top, 5)
                    }
                }
                .padding(.top, 1)
                .navigationBarTitle("Routine".localized)
                .if(!routines.isEmpty) {
                    $0.navigationBarItems(
                        trailing: addRoutineButton
                    )
                }
                .sheet(item: $isAddSheet) { sheetType in
                    switch sheetType {
                    case RoutineSheet.add:
                        AddRoutine()
                            .environment(\.managedObjectContext, managedObjectContext)
                            .environmentObject(displayManager)
                            .allowAutoDismiss(false)
                    case RoutineSheet.edit(let routine):
                        EditRoutine(routine: routine)
                            .allowAutoDismiss(false)
                    }
                }
            }
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    var addRoutineButton: some View {
        Button(action: {
            self.isAddSheet = .add
        }) {
            Image(systemName: "plus")
                .font(.system(size: 25))
        }
    }
}

struct RoutineMainView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineView()
    }
}
