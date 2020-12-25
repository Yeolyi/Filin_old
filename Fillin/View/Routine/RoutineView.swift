//
//  RoutineMainView.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

struct RoutineView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var displayManager: DisplayManager
    
    @State var isAddSheet = false
    
    var body: some View {
        NavigationView {
            Text("asd")
                .navigationBarTitle("Routine".localized)
                .navigationBarItems(
                    trailing: addRoutineButton
                )
                .sheet(isPresented: $isAddSheet) {
                    AddRoutine()
                        .environment(\.managedObjectContext, managedObjectContext)
                        .environmentObject(displayManager)
                }
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    var addRoutineButton: some View {
        Button(action: {
            self.isAddSheet = true
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
