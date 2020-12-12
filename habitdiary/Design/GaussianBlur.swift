//
//  GaussianBlur.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct GaussBlur: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Blur(style: .systemMaterial)
            )
    }
}

extension View {
    func gaussBlur() -> some View {
        return modifier(GaussBlur())
    }
}
