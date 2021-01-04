//
//  ListRow.swift
//  FoodLuxMea
//
//  Created by Seong Yeol Yi on 2020/09/18.
//

import SwiftUI

struct RowBackground: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
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
    func rowBackground() -> some View {
        return modifier(RowBackground())
    }
}

struct RowBackground_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
            .rowBackground()
    }
}
