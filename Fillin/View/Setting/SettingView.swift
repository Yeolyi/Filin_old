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
    @EnvironmentObject var displayManager: DisplayManager
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.managedObjectContext) var context
    @State var isReorderSheet = false
    @State var isDefaultTabExpanded = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Text("General".localized)
                        .sectionText()
                    NavigationLink(
                        destination:
                            DefaultTabSetting()
                    ) {
                        VStack {
                            HStack {
                                Text("Change default tab".localized)
                                    .rowHeadline()
                                Spacer()
                            }
                            .rowBackground()
                        }
                    }
                    Text("Display".localized)
                        .sectionText()
                    Button(action: {self.isReorderSheet = true}) {
                        HStack {
                            Text("Change list order".localized)
                                .rowHeadline()
                            Spacer()
                        }
                        .rowBackground()
                    }
                }
            }
            .padding(.top, 1)
            .navigationBarTitle("Setting".localized)
        }
        .sheet(isPresented: $isReorderSheet) {
            ListReorderSheet()
            .environment(\.managedObjectContext, context)
            .environmentObject(displayManager)
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
