//
//  ListRow.swift
//  FoodLuxMea
//
//  Created by Seong Yeol Yi on 2020/09/18.
//

import SwiftUI

/// Cornered list row background
struct RowBackground: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let corners: UIRectCorner
    func body(content: Content) -> some View {
        Group {
            VStack(spacing: 0) {
                content
                    .padding(.top, 21)
                    .padding(.bottom, 5)
                Divider()
            }
            .padding(.horizontal, 20)
        }
    }
}

extension View {
    func rowBackground(corners: UIRectCorner = .allCorners) -> some View {
        return modifier(RowBackground(corners: corners))
    }
}

struct RowBackground_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
            .rowBackground(corners: .bottomLeft)
    }
}
