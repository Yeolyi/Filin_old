//
//  ProfileSettingView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/21.
//

import SwiftUI

struct ProfileSettingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var summaryManager: SummaryManager

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
                    SummaryStateRow(num: 1, targetHabit: $summaryManager.contents[0].first)
                    SummaryStateRow(num: 2, targetHabit: $summaryManager.contents[0].second)
                    SummaryStateRow(num: 3, targetHabit: $summaryManager.contents[0].third)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .accentColor(ThemeColor.mainColor(colorScheme))
        }
    }
}

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        _ = DataSample.shared
        return ProfileSettingView()
    }
}
