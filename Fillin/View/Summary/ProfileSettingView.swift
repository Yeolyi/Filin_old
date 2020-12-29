//
//  ProfileSettingView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/21.
//

import SwiftUI

struct TempRingManager {
    var name: String
    var first: UUID?
    var second: UUID?
    var third: UUID?
    mutating func setByNumber(_ num: Int, id: UUID?) {
        switch num {
        case 1: first = id
        case 2: second = id
        case 3: third = id
        default:
            assertionFailure()
        }
    }
    func getByNumber(_ num: Int) -> UUID? {
        switch num {
        case 1: return first
        case 2: return second
        case 3: return third
        default:
            assertionFailure()
            return first
        }
    }
}

struct ProfileSettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var displayManager: DisplayManager
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
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var localSummaryProfile = TempRingManager(name: "Default")
    
    var body: some View {
        NavigationView {
            VStack {
                InlineNavigationBar(
                    title: "Summary Setting".localized,
                    button1: {
                        Button(action: saveAndExit) {
                            Text("Save".localized)
                                .headerButton()
                        }
                    },
                    button2: {
                        EmptyView()
                    }
                )
                ScrollView {
                    settingRow(num: 1)
                    settingRow(num: 2)
                    settingRow(num: 3)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .onAppear {
            if !summaryProfile.isEmpty {
                localSummaryProfile.first = summaryProfile[0].first
                localSummaryProfile.second = summaryProfile[0].second
                localSummaryProfile.third = summaryProfile[0].third
            }
        }
    }
    func settingRow(num: Int) -> some View {
        let numToStr: String
        let targetID: UUID?
        switch num {
        case 1:
            numToStr = "Habit 1(Outermost ring)".localized
            targetID = localSummaryProfile.first
        case 2:
            numToStr = "Habit 2".localized
            targetID = localSummaryProfile.second
        case 3:
            numToStr = "Habit 3(Innermost ring)".localized
            targetID = localSummaryProfile.third
        default:
            assertionFailure()
            numToStr = "First ring".localized
            targetID = nil
        }
        return ZStack {
            HStack {
                Text(numToStr)
                    .rowHeadline()
                    .mainColor()
                Spacer()
                Text(habitInfos.first(where: {$0.id == targetID})?.name ?? "Empty".localized)
                    .mainColor()
            }
            NavigationLink(destination: SetHabitForRing(position: num, localSummaryProfile: $localSummaryProfile)) {
                Rectangle()
                    .opacity(0)
            }
        }
        .rowBackground()
    }
    func saveAndExit() {
        if summaryProfile.isEmpty {
            Summary.saveSummary(
                id: UUID(), name: localSummaryProfile.name,
                first: localSummaryProfile.first, second: localSummaryProfile.second,
                third: localSummaryProfile.third, managedObjectContext: managedObjectContext
            )
        } else {
            summaryProfile[0].edit(
                first: localSummaryProfile.first, second: localSummaryProfile.second,
                third: localSummaryProfile.third, managedObjectContext: managedObjectContext
            )
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct SetHabitForRing: View {
    let position: Int
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    @Binding var localSummaryProfile: TempRingManager
    var body: some View {
        ScrollView {
            VStack {
                ForEach(habitInfos, id: \.self) { habit in
                    Button(action: {
                        localSummaryProfile.setByNumber(position, id: habit.id)
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(habit.name)
                                .mainColor()
                                .rowHeadline()
                            Spacer()
                            if localSummaryProfile.getByNumber(position) == habit.id {
                                Image(systemName: "checkmark")
                                    .mainColor()
                            }
                        }
                    }
                    .rowBackground()
                }
                Button(action: {
                    localSummaryProfile.setByNumber(position, id: nil)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text("Empty".localized)
                            .mainColor()
                            .rowHeadline()
                        Spacer()
                    }
                    .rowBackground()
                }
            }
            .padding(.top, 1)
        }
    }
}

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingView()
    }
}
