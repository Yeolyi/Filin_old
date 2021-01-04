//
//  ProfileSettingView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/21.
//

import SwiftUI

struct ProfileSettingView: View {
    
    @State var firstRingName = ""
    @State var secondRingName = ""
    @State var thirdRingName = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("Summary Setting".localized)
                            .headline()
                        Spacer()
                    }
                    .padding(20)
                    Divider()
                }
                ScrollView {
                    SummaryStateRow(num: 1, ringName: $firstRingName)
                    SummaryStateRow(num: 2, ringName: $secondRingName)
                    SummaryStateRow(num: 3, ringName: $thirdRingName)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .accentColor(ThemeColor.mainColor(colorScheme))
        }
        .onAppear {
            firstRingName = summaryHabitName(1)
            secondRingName = summaryHabitName(2)
            thirdRingName = summaryHabitName(3)
        }
    }
    
    func summaryHabitName(_ num: Int) -> String {
        guard let id = summary[0].getByNumber(num) else {
            return "Empty".localized
        }
        if let habit = habitInfos.first(where: {$0.id == id}) {
            return habit.name
        } else {
            return "Empty".localized
        }
    }
    
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
    @Environment(\.managedObjectContext) var managedObjectContext
}

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview()
        ProfileSettingView()
            .environment(\.managedObjectContext, coreDataPreview.context)
    }
}

