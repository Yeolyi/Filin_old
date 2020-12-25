//
//  ProfileSettingView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/21.
//

import SwiftUI

struct ProfileSettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var displayManager: DisplayManager
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    @State var localSummaryProfile = SummaryProfile(name: "기본")
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
            if !displayManager.summaryProfile.isEmpty {
                localSummaryProfile = displayManager.summaryProfile[0]
            }
        }
    }
    func settingRow(num: Int) -> some View {
        let numToStr: String
        let targetID: UUID?
        switch num {
        case 1:
            numToStr = "First ring".localized
            targetID = localSummaryProfile.first
        case 2:
            numToStr = "Second ring".localized
            targetID = localSummaryProfile.second
        case 3:
            numToStr = "Third ring".localized
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
        displayManager.summaryProfile = [localSummaryProfile]
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct SetHabitForRing: View {
    let position: Int
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Binding var localSummaryProfile: SummaryProfile
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
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
                        Text("None".localized)
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
