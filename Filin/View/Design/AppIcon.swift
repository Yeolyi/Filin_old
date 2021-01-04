//
//  IconNewDesign.swift
//  D-day
//
//  Created by Seong Yeol Yi on 2020/03/05.
//  Copyright © 2020 seongyeol Yi. All rights reserved.
//

import SwiftUI

struct AppIcon: View {
    var body: some View {
        GeometryReader{ geo in
            /*
            Path { path in
                let size = min(geometry.size.width, geometry.size.height)
                path.move(to: .init(x: size * 0.2, y: size * 0.2))
                path.addQuadCurve(to: .init(x: size * 0.2, y: size * 0.8), control: .init(x: size * 1.0, y: size * 0.5))
                path.addQuadCurve(to: .init(x: size * 0.2, y: size * 0.2), control: .init(x: size * 0.3, y: size * 0.5))
           }
            .fill(Color.white)
            */
            ZStack {
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: geo.size.width*0.5, height: geo.size.height*0.5)
                    .overlay(
                        Circle()
                            .trim(from: 0.0, to: 0.7)
                            .stroke(style: StrokeStyle(lineWidth: 40.0, lineCap: .square, lineJoin: .bevel))
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: -90))
                            .overlay(
                                Circle()
                                    .trim(from: 0.0, to: 0.7)
                                    .stroke(style: StrokeStyle(lineWidth: 40.0, lineCap: .square, lineJoin: .bevel))
                                    .foregroundColor(.gray)
                                    .rotationEffect(Angle(degrees: -90))
                                    .offset(x: -15, y: 15)
                            )
                    )
            }
            .offset(x: geo.size.width*0.25 + 10, y: geo.size.width*0.25 - 10)
        }
        .aspectRatio(1, contentMode: .fit)
        .scaledToFit()
        .background(LinearGradient(
            gradient: .init(colors: [ThemeColor.mainColor(.dark), ThemeColor.mainColor(.light)]),
            startPoint: .init(x: 0.8, y: 0),
            endPoint: .init(x: 0.8, y: 1.0)
        ))
    }
}

struct IconNewDesign_Previews: PreviewProvider {
    static var previews: some View {
        AppIcon()
    }
}
