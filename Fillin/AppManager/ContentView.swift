//
//  HabitListView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    @State var defaultTap: Int
    init(defaultTap: Int) {
        self._defaultTap = State(initialValue: defaultTap)
    }
    var body: some View {
        TabView(selection: $defaultTap) {
            HabitListView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("List".localized)
                }
                .tag(0)
            SummaryView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Summary".localized)
                }
                .tag(1)
            Text("Hello")
                .tabItem {
                    Image(systemName: "rectangle.stack")
                    Text("Routine".localized)
                }
                .tag(2)
            SettingView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Setting".localized)
                }
                .tag(3)
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(defaultTap: 0)
    }
}
