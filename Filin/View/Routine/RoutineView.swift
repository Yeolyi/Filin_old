//
//  RoutineMainView.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

enum RoutineSheet: Identifiable {
    case add
    case edit(RoutineContext)
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
    
    @State var isAddSheet: RoutineSheet?
    
    @ObservedObject var routineManager = RoutineContextManager.shared
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if !routineManager.contents.isEmpty {
                        Text("Today".localized)
                            .sectionText()
                        VStack(spacing: 0) {
                            ForEach(routineManager.contents) { routine in
                                RoutineRow(routine: routine, isSheet: $isAddSheet)
                            }
                        }
                    } else {
                        ForEach([RoutineContext.sample1, RoutineContext.sample2], id: \.self) { routine in
                            RoutineRow(routine: routine, isSheet: $isAddSheet)
                        }
                        .opacity(0.5)
                        .disabled(true)
                        Text("Group and repeat goals to make them a habit.".localized)
                            .bodyText()
                            .padding(.top, 34)
                        MainRectButton(action: {
                            isAddSheet = .add
                        }, str: "Add routine".localized)
                        .padding(.top, 13)
                    }
                }
                .padding(.top, 1)
                .navigationBarTitle("Routine".localized)
                .navigationBarItems(
                    trailing: HeaderButton("plus") {
                        self.isAddSheet = .add
                    }
                )
                .sheet(item: $isAddSheet) { sheetType in
                    switch sheetType {
                    case RoutineSheet.add:
                        AddRoutine()
                    case RoutineSheet.edit(let routine):
                        EditRoutine(routine: routine)
                            .accentColor(ThemeColor.mainColor(colorScheme))
                    }
                }
            }
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
