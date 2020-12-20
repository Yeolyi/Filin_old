//
//  FontsModifiers.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/17.
//

import SwiftUI

struct RowSubheadline: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16))
            .foregroundColor(ThemeColor.mainColor(colorScheme))
    }
}

extension View {
    func rowSubheadline() -> some View {
        return modifier(RowSubheadline())
    }
}
