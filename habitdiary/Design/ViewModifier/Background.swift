//
//  Background.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/17.
//

import SwiftUI

struct PaperBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.white
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .overlay(content)
        }
    }
}

extension View {
    func paperBackground() -> some View {
        return modifier(PaperBackground())
    }
}
