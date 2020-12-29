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
    @FetchRequest(
        entity: Summary.entity(),
        sortDescriptors: []
    )
    var summaryProfile: FetchedResults<Summary>
    var isSummaryExist: Bool {
        if summaryProfile.isEmpty {
            return false
        } else if summaryProfile[0].isEmpty {
            return false
        } else {
            return true
        }
    }
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var displayManager: DisplayManager
    @State var updated = false
    @State var selectedDate = Date()
    @State var isSettingSheet = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if isSummaryExist {
                        Text("Calendar".localized)
                            .sectionText()
                        RingRow(selectedDate: $selectedDate, habits: firstThreeElements())
                        TodaySummary(selectedDate: $selectedDate)
                    } else {
                        RingRow(
                            selectedDate: .constant(Date()),
                            habits: [sampleHabit(name: ""), sampleHabit(name: "")]
                        )
                            .opacity(0.5)
                            .disabled(true)
                        Text("See information of goals at once.")
                            .rowHeadline()
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        ListEmptyButton(
                            action: { isSettingSheet = true },
                            str: "Select goals".localized
                        )
                        .padding(.top, 5)
                    }
                }
            }
            .padding(.top, 1)
            .navigationBarTitle("Summary".localized)
            .if(isSummaryExist) {
                $0.navigationBarItems(
                    trailing: editButton
                )
            }
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
            let image = RingRow(selectedDate: $selectedDate, habits: firstThreeElements(), isExpanded: true).asImage().pngData()!
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
        if summaryProfile.isEmpty {
            return []
        }
        for id in summaryProfile[0].idArray {
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
