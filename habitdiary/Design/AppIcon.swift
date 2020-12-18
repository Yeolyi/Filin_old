//
//  Icon.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct AppIcon: View {
    var progress: Double
    let color: Color
    let num: String?
    let isUnderBar: Bool
    let highlighted: Bool
    let activated: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .foregroundColor(.clear)
                    .overlay(
                        Circle()
                            .trim(from: 0.0, to: CGFloat(self.progress))
                            .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .square, lineJoin: .bevel))
                            .foregroundColor(color)
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear)
                    )
                    .if(progress > 1){
                        $0
                        .overlay(
                            Circle()
                                .trim(from: 0.0, to: CGFloat(self.progress - 1))
                                .stroke(style: StrokeStyle(lineWidth: 40, lineCap: .square, lineJoin: .bevel))
                                .foregroundColor(color.darker(by: 0.2))
                                .rotationEffect(Angle(degrees: 270.0))
                                .animation(.linear)
                        )
                    }
                    .zIndex(0)
                Image(systemName: "pencil")
                    .font(.system(size: 90, weight: .bold))
                    .foregroundColor(ThemeColor.secondaryColor)
            }
        }
    }
}

struct AppIcon_Previews: PreviewProvider {
    static var previews: some View {
        AppIcon(progress: 0.8, color: ThemeColor.mainColor, num: "14", isUnderBar: true, highlighted: false, activated: true)
            .frame(width: 210)
    }
}
