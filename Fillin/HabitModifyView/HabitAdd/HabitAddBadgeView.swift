//
//  HabitAddBadgeView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct HabitAddBadgeView<Content: View>: View {
    let title: String
    let imageSystemName: String
    let content: Content
    @Environment(\.colorScheme) var colorScheme
    init(title: String, imageName: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.imageSystemName = imageName
        self.content = content()
    }
    var body: some View {
        VStack {
            Image(systemName: imageSystemName)
                .font(.system(size: 70, weight: .semibold))
                .foregroundColor(ThemeColor.mainColor(colorScheme))
                .padding(.bottom, 10)
                .padding(.top, 30)
            Text(title)
                .title()
            Spacer()
            content
            Spacer()
        }
    }
}

/*
struct HabitAddBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        HabitAddBadgeView()
    }
}
*/