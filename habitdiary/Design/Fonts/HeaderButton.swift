//
//  HeaderButton.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct HeaderButton: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .padding(.trailing, 20)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(ThemeColor.mainColor(colorScheme))
    }
}

extension View {
    func headerButton() -> some View {
        return modifier(HeaderButton())
    }
}
