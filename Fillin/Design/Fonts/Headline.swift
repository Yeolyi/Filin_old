//
//  RowHeadline.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/19.
//

import SwiftUI

struct Headline: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .bold))
            .mainColor()
    }
}

extension View {
    func headline() -> some View {
        return modifier(Headline())
    }
}
