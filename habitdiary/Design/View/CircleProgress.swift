//
//  CircleProgress.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct CircleProgress: View {
    var progress: Double
    let color: Color
    let num: String?
    let isUnderBar: Bool
    let highlighted: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .foregroundColor(color.opacity(highlighted ? 0.6 : 0.2))
                    .overlay(
                        Circle()
                            .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                            .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                            .foregroundColor(color)
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear)
                    )
                    .zIndex(0)
                if num != nil {
                    Text("\(num!)")
                        .if(isUnderBar) { $0.underline() }
                        .font(.system(size: geo.size.height > geo.size.width ? geo.size.width * 0.4: geo.size.height * 0.4, weight: .semibold))
                        .foregroundColor(.black)
                        .zIndex(1)
                }
            }
        }
    }
}

struct CircleProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgress(progress: 0.5, color: .blue, num: "10", isUnderBar: false, highlighted: false)
    }
}
