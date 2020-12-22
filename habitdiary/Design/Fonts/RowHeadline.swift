//
//  RowHeadline.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/19.
//

import SwiftUI

struct RowHeadline: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(ThemeColor.mainColor(colorScheme))
    }
}

extension View {
    func rowHeadline() -> some View {
        return modifier(RowHeadline())
    }
}
