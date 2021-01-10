//
//  CalendarSummaryView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct SummaryView: View {

    @State var updated = false
    @State var selectedDate = Date()
    @State var isSettingSheet = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var summaryManager: SummaryContextManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if summaryManager.contents.isEmpty || summaryManager.contents[0].isEmpty {
                        SummaryPreview(isSettingSheet: $isSettingSheet)
                    } else {
                        RingsCalendar(
                            selectedDate: $selectedDate,
                            habit1: summaryManager.contents[0].first,
                            habit2: summaryManager.contents[0].second,
                            habit3: summaryManager.contents[0].third
                        )
                        ForEach(summaryManager.contents[0].habitArray.compactMap({$0}), id: \.id) { habit in
                            HabitRow(habit: habit, showAdd: false, date: selectedDate)
                        }
                    }
                }
            }
            .padding(.top, 1)
            .navigationBarTitle("Summary".localized)
            .navigationBarItems(
                trailing: HeaderText("Edit".localized) {
                    isSettingSheet = true
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $isSettingSheet) {
            ProfileSettingView()
                .accentColor(ThemeColor.mainColor(colorScheme))
                .environmentObject(summaryManager)
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .onAppear {
            if summaryManager.contents.isEmpty {
                summaryManager.addObject(.init(id: UUID(), name: "Default"))
            }
        }
    }
}

/*
struct CalendarSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        _ = CoreDataPreview.shared
        return SummaryView()
    }
}
*/
