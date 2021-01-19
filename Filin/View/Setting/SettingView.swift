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
                        Text("Start week on Monday".localized)
                            .bodyText()
                        Spacer()
                        PaperToggle($appSetting.isMondayStart)
                    }
                    .rowBackground()
                    #if DEBUG
                    Button(action: {
                        _ = CoreDataPreview.shared
                    }) {
                        HStack {
                            Text("샘플")
                                .bodyText()
                            Spacer()
                        }
                        .onTapGesture {
                            
                        }
                        .rowBackground()
                    }
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
            .environmentObject(AppSetting())
    }
}
