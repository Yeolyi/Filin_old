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

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if summary.isEmpty || summary[0].isEmpty {
                        SummaryPreview(isSettingSheet: $isSettingSheet)
                    } else {
                        RingCalendar(selectedDate: $selectedDate, habits: firstThreeElements())
                        TodaySummary(selectedDate: $selectedDate)
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
                .environment(\.managedObjectContext, context)
                .accentColor(ThemeColor.mainColor(colorScheme))
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .onAppear {
            if summary.isEmpty {
                Summary.save(name: "Default", first: nil, second: nil, third: nil, managedObjectContext: context)
            }
        }
    }
    func firstThreeElements() -> [Habit?] {
        var tempArray: [Habit?] = []
        for id in summary[0].idArray {
            if id == nil {
                tempArray.append(nil)
                continue
            }
            if let habit = habitInfos.first(where: {$0.id == id}) {
                tempArray.append(habit)
            }
        }
        return tempArray
    }
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var displayManager: DisplayManager
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    @FetchRequest(
        entity: Summary.entity(),
        sortDescriptors: []
    )
    var summary: FetchedResults<Summary>
    
}

struct CalendarSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview()
        return SummaryView()
            .environment(\.managedObjectContext, coreDataPreview.context)
            .environmentObject(coreDataPreview.displayManager)
    }
}
