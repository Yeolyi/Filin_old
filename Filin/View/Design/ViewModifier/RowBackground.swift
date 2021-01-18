//
//  ListRow.swift
//  FoodLuxMea
//
//  Created by Seong Yeol Yi on 2020/09/18.
//

import SwiftUI

struct RowBackground: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let isBottomPadding: Bool
    
    init(_ isBottomPadding: Bool = true) {
        self.isBottomPadding = isBottomPadding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.top, 20)
            .padding(.bottom, isBottomPadding ? 20 : 0)
            .padding(.horizontal, 10)
            .background(
                Color(hex: colorScheme == .light ? "#F2F2F2" : "#202020")
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
    }
}

extension View {
    func rowBackground(_ isBottomPadding: Bool = true) -> some View {
        return modifier(RowBackground(isBottomPadding))
    }
}

struct RowBackground_Previews: PreviewProvider {
    static var previews: some View {
        HabitRow(habit: HabitContext(name: "Text"), showAdd: true)
    }
}
