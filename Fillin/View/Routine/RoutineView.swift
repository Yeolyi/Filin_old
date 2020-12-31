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
                        Text("Today".localized)
                            .sectionText()
                        VStack(spacing: 0) {
                            ForEach(routines, id: \.self) { routine in
                                RoutineRow(routine: routine, isSheet: $isAddSheet)
                            }
                        }
                    } else {
                        ForEach([
                            sampleRoutine(name: "After wake up".localized, dayOfTheWeek: [1, 2, 3, 4, 5, 6, 7], time: "07-00"),
                            sampleRoutine(name: "Before bed".localized, dayOfTheWeek: [1, 2, 3, 4, 5, 6, 7], time: "23-30")
                        ], id: \.self) { routine in
                            RoutineRow(routine: routine, isSheet: $isAddSheet)
                        }
                        .opacity(0.5)
                        .disabled(true)
                        Text("Group and repeat goals to make them a habit.".localized)
                            .bodyText()
                            .padding(.top, 34)
                        ListEmptyButton(action: {
                            isAddSheet = .add
                        }, str: "Add routine".localized)
                        .padding(.top, 13)
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
                    case RoutineSheet.edit(let routine):
                        EditRoutine(routine: routine)
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
