//
//  CircleProgress.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct CircleProgress<Content: View>: View {
    var progress: Double
    let accentColor: Color
    let content: Content
    @Environment(\.colorScheme) var colorScheme
    init(progress: Double, accentColor: Color, @ViewBuilder content: @escaping () -> Content) {
        self.progress = progress
        self.accentColor = accentColor
        self.content = content()
    }
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.clear)
                .overlay(
                    Circle()
                        .trim(from: 0.0, to: CGFloat(self.progress))
                        .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .square, lineJoin: .bevel))
                        .foregroundColor(accentColor)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear)
                )
                .if(progress > 1) {
                    $0.overlay(
                        Circle()
                            .trim(from: 0.0, to: CGFloat(self.progress - 1))
                            .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .square, lineJoin: .bevel))
                            .foregroundColor(accentColor.darker(by: 0.2))
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear)
                    )
                }
                .zIndex(0)
            content
        }
    }
}

struct CircleProgress_Previews: PreviewProvider {
    @Environment(\.colorScheme) var colorScheme
    static var previews: some View {
        CircleProgress(
            progress: 0.31415,
            accentColor: .blue
        ) {
            Text("15")
        }
        .frame(width: 50, height: 50, alignment: .center)
    }
}
