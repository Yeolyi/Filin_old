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
    let appVersion: String
    let build: String
    
    init() {
        appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        build = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    NavigationLink(
                        destination:
                            DefaultTabSetting()
                    ) {
                        VStack {
                            HStack {
                                Text("Change Default Tab".localized)
                                    .bodyText()
                                Spacer()
                            }
                            .rowBackground()
                        }
                    }
                    HStack {
                        Text("App Version".localized)
                            .bodyText()
                        Spacer()
                        Text("\(appVersion)")
                    }
                    .rowBackground()
                    HStack {
                        Text("Build".localized)
                            .bodyText()
                        Spacer()
                        Text("\(build)")
                    }
                    .rowBackground()
                    #if DEBUG
                    HStack {
                        Text("샘플")
                            .bodyText()
                        Spacer()
                    }
                    .onTapGesture {
                        _ = CoreDataPreview.shared
                    }
                    .rowBackground()
                    #endif
                }
            }
            .padding(.top, 1)
            .navigationBarTitle("Setting".localized)
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
