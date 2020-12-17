//
//  Icon.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct AppIcon: View {
    var body: some View {
        ZStack {
        Circle()
            .foregroundColor(Color(hex: "#f7ebad"))
            .overlay(
                Circle()
                    .trim(from: 0.0, to: 0.8)
                    .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color(hex: "#f7ebad").darker(by: 0.15))
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear)
            )
            .zIndex(0)
            Text("✓")
                .font(.system(size: 150, weight: .semibold))
                .foregroundColor(.black)
                .zIndex(1)
        }
        .aspectRatio(1, contentMode: .fit)
        .scaledToFit()
    }
}

struct AppIcon_Previews: PreviewProvider {
    static var previews: some View {
        AppIcon()
    }
}
