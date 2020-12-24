//
//  Background.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/17.
//

import SwiftUI

struct KeyboardTouchAreaBackground: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        ZStack {
            (colorScheme == .light ?  Color.white : Color.black)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .overlay(content)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

extension View {
    func keyboardTouchAreaBackground() -> some View {
        return modifier(KeyboardTouchAreaBackground())
    }
}
