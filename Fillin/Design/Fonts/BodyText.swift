//
//  FontsModifiers.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/17.
//

import SwiftUI

struct BodyText: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(ThemeColor.mainColor(colorScheme))
    }
}

extension View {
    func bodyText() -> some View {
        return modifier(BodyText())
    }
}
