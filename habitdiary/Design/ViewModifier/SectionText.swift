//
//  SectionText.swift
//  FoodLuxMea
//
//  Created by Seong Yeol Yi on 2020/08/23.
//

import SwiftUI

/// Substitutes SwiftUI list section header
struct SectionText: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
                .font(.system(size: 20, weight: .bold))
                .padding(.leading, 12)
                .padding(.top, 15)
            Spacer()
        }
    }
}

extension View {
    func sectionText() -> some View {
        return modifier(SectionText())
    }
}
