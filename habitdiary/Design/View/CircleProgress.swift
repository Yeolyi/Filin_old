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
    let activated: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .foregroundColor(.clear)
                    .overlay(
                        Circle()
                            .trim(from: 0.0, to: CGFloat(self.progress))
                            .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .square, lineJoin: .bevel))
                            .foregroundColor(color)
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear)
                    )
                    .if(progress > 1){
                        $0
                        .overlay(
                            Circle()
                                .trim(from: 0.0, to: CGFloat(self.progress - 1))
                                .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .square, lineJoin: .bevel))
                                .foregroundColor(color.darker(by: 0.2))
                                .rotationEffect(Angle(degrees: 270.0))
                                .animation(.linear)
                        )
                    }
                    .zIndex(0)
                if num != nil {
                    Text("\(num!)")
                        .if(isUnderBar) { $0.underline() }
                        .font(.system(size: 16))
                        //.font(.system(size: geo.size.height > geo.size.width ? geo.size.width * 0.4: geo.size.height * 0.4, weight: .semibold))
                        .foregroundColor(highlighted ? color : (activated ? ThemeColor.mainColor : ThemeColor.secondaryColor))
                        .zIndex(1)
                }
            }
        }
    }
}

struct CircleProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgress(progress: 0.31415, color: ThemeColor.mainColor, num: "15", isUnderBar: false, highlighted: false, activated: false)
            .frame(width: 50, height: 50, alignment: .center)
    }
}
