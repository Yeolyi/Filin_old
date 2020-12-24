//
//  SettingView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI
import Combine

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Default tab")
                        .sectionText()
                    ForEach(DefaultTap.allCases, id: \.self) { tapName in
                        Button(action: {
                            appSetting.defaultTap = tapName.rawValue
                        }) {
                            HStack {
                                Text(tapName.string)
                                    .rowHeadline()
                                Spacer()
                                if tapName.rawValue == appSetting.defaultTap {
                                    Image(systemName: "checkmark")
                                        .mainColor()
                                }
                            }
                        }
                    }
                    .rowBackground()
                }
            }
            .padding(.top, 1)
            .navigationBarTitle("Setting".localized)
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
