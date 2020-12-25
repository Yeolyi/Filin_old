//
//  CalendarSummaryView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct SummaryView: View {
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var displayManager: DisplayManager
    @State var updated = false
    @State var selectedDate = Date()
    @State var isSettingSheet = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Group {
                        Text("Calendar".localized)
                            .sectionText()
                        if !displayManager.summaryProfile.isEmpty {
                            CalendarRow(selectedDate: $selectedDate, habits: firstThreeElements())
                            TodaySummary(selectedDate: $selectedDate)
                        } else {
                            HStack {
                                Spacer()
                                Text("Empty".localized)
                                    .foregroundColor(ThemeColor.subColor(colorScheme))
                                Spacer()
                            }
                            .rowBackground()
                        }
                    }
                }
            }
            .padding(.top, 1)
            .navigationBarTitle("Summary".localized)
            .navigationBarItems(
                trailing: editButton
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $isSettingSheet) {
            ProfileSettingView()
                .environment(\.managedObjectContext, managedObjectContext)
                .accentColor(ThemeColor.mainColor(colorScheme))
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
    }
    var shareButton: some View {
        Button(action: {
            let image = CalendarRow(selectedDate: $selectedDate, habits: firstThreeElements(), isExpanded: true).asImage().pngData()!
            SharingHandler.instagramStory(imageData: image)
        }) {
            Image(systemName: "square.and.arrow.up")
                .mainColor()
                .font(.system(size: 24, weight: .medium))
        }
    }
    var editButton: some View {
        Button(action: {
            isSettingSheet = true
        }) {
            Text("Edit".localized)
        }
    }
    func firstThreeElements() -> [Habit?] {
        var tempArray: [Habit?] = []
        if displayManager.summaryProfile.isEmpty {
            return []
        }
        for id in displayManager.summaryProfile[0].idArray {
            if id == nil {
                tempArray.append(nil)
                continue
            }
            if let habit = habitInfos.first(where: {$0.id==id}) {
                tempArray.append(habit)
            }
        }
        return tempArray
    }
}

struct CalendarSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
