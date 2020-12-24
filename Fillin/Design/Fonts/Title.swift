//
//  TItle.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/19.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 30, weight: .heavy))
    }
}

extension View {
    func title() -> some View {
        return modifier(Title())
    }
}
