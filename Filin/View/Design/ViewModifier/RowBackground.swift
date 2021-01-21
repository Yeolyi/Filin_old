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
    let verticalPadding: CGFloat
    let outerVerticalPadding: CGFloat
    let horizontalPadding: CGFloat
    
    init(_ isBottomPadding: Bool = true, _ verticalPadding: CGFloat = 20, _ outerVerticalPadding: CGFloat = 10, _ horizontalPadding: CGFloat = 10) {
        self.isBottomPadding = isBottomPadding
        self.verticalPadding = verticalPadding
        self.outerVerticalPadding = outerVerticalPadding
        self.horizontalPadding = horizontalPadding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.top, verticalPadding)
            .padding(.bottom, isBottomPadding ? verticalPadding : 0)
            .padding(.horizontal, 10)
            .background(
                Rectangle()
                    .foregroundColor(Color(hex: colorScheme == .light ? "#FFFFFF" : "#000000"))
                    .cornerRadius(10)
                    .shadow(color: (colorScheme == .light ? Color.gray.opacity(0.6) : Color.gray.opacity(0.45)), radius: 5, x: 3, y: 3)
            )
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, outerVerticalPadding)
    }
}

extension View {
    func rowBackground(_ isBottomPadding: Bool = true, _ verticalPadding: CGFloat = 20,
                       _ outerVerticalPadding: CGFloat = 10, _ horizontalPadding: CGFloat = 10) -> some View {
        return modifier(RowBackground(isBottomPadding, verticalPadding, outerVerticalPadding, horizontalPadding))
    }
}

struct RowBackground_Previews: PreviewProvider {
    static var previews: some View {
        HabitRow(habit: HabitContext(name: "Text"), showAdd: true)
            .environmentObject(AppSetting())
    }
}
