//
//  Icon.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct AppIcon: View {
    var body: some View {
        GeometryReader{geometry in
            Path { path in
                let size = min(geometry.size.width, geometry.size.height)
                path.move(to: .init(x: size * 0.2, y: size * 0.2))
                path.addQuadCurve(to: .init(x: size * 0.2, y: size * 0.8), control: .init(x: size * 1.0, y: size * 0.5))
                path.addQuadCurve(to: .init(x: size * 0.2, y: size * 0.2), control: .init(x: size * 0.3, y: size * 0.5))
           }
            .fill(LinearGradient(
                gradient: .init(colors: [Color(UIColor.systemPink).opacity(0.4), Color(UIColor.systemPink).opacity(0.9)]),
                startPoint: .init(x: 0.2, y: 0.2),
                endPoint: .init(x: 0.2, y: 0.8)
            ))
            Path { path in
                 let size = min(geometry.size.width, geometry.size.height)
                 path.move(to: .init(x: size * 0.8, y: size * 0.2))
                 path.addQuadCurve(to: .init(x: size * 0.8, y: size * 0.8), control: .init(x: size * 0.0, y: size * 0.5))
                 path.addQuadCurve(to: .init(x: size * 0.8, y: size * 0.2), control: .init(x: size * 0.7, y: size * 0.5))
            }
             .fill(LinearGradient(
                gradient: .init(colors: [Color(UIColor.systemPink).opacity(0.4), Color(UIColor.systemPink).opacity(0.9)]),
                 startPoint: .init(x: 0.8, y: 0.2),
                 endPoint: .init(x: 0.8, y: 0.8)
             ))
            Path { path in
                 let size = min(geometry.size.width, geometry.size.height)
                 path.move(to: .init(x: size * 0.5, y: size * 0.3))
                path.addLine(to: .init(x: size * 0.75, y: size * 0.15))
                path.addQuadCurve(to: .init(x: size * 0.25, y: size * 0.15), control: .init(x: size * 0.5, y: size * 0.3))
                 path.addLine(to: .init(x: size * 0.5, y: size * 0.3))
            }
             .fill(LinearGradient(
                 gradient: .init(colors: [Color(UIColor.systemPink).opacity(0.1), Color(UIColor.systemPink).opacity(0.5)]),
                 startPoint: .init(x: 0.5, y: 0.15),
                 endPoint: .init(x: 0.5, y: 0.3)
             ))
            
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
