//
//  HabitListView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        TabView {
            HabitListView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("List".localized)
                }
            SummaryView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Summary".localized)
                }
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
