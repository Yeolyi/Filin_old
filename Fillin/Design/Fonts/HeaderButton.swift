//
//  HeaderButton.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct BasicButton: View {
    let action: () -> Void
    let imageName: String
    
    init(_ imageName: String, action: @escaping () -> Void) {
        self.imageName = imageName
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .subColor()
                .font(.system(size: 24, weight: .semibold))
                .frame(width: 44, height: 44)
        }
    }
}

struct HeaderButton: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .padding(.trailing, 20)
            .bodyText()
            .foregroundColor(ThemeColor.mainColor(colorScheme))
            .frame(width: 44, height: 44)
    }
}

extension View {
    func headerButton() -> some View {
        return modifier(HeaderButton())
    }
}
