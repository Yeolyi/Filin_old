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
        case .edit(_):
            return 1
        }
    }
}

struct RoutineView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var displayManager: DisplayManager
    @FetchRequest(entity: Routine.entity(), sortDescriptors: [])
    var routines: FetchedResults<Routine>
    
    @State var isAddSheet: RoutineSheet?
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("List".localized)
                    .sectionText()
                VStack(spacing: 0) {
                    ForEach(routines, id: \.self) { routine in
                        RoutineRow(routine: routine, isSheet: $isAddSheet)
                    }
                }
            }
            .padding(.top, 1)
            .navigationBarTitle("Routine".localized)
            .navigationBarItems(
                trailing: addRoutineButton
            )
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
