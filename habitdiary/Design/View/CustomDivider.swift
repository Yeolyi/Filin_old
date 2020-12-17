//
//  CustomDivider.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/17.
//

import SwiftUI

struct CustomDivider: View {
    let size: CGFloat = 0.5
    let edge: Edge.Set
    var body: some View {
        Rectangle()
            .fill(Color(hex: "#737373"))
            .if(edge == .horizontal) {
                $0.frame(height: size)
            }
            .if(edge == .vertical) {
                $0.frame(width: size)
            }
            .edgesIgnoringSafeArea(edge)
    }
}
