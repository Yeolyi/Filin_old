//
//  ColorGauge.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct LinearProgressBar: View {
    
    let color: Color
    let progress: Double
    
    init(color: Color, progress: Double) {
        self.color = color
        self.progress = max(0, min(progress, 1))
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geo.size.width, height: 10)
                    .foregroundColor(color.lighter(by: 0.4))
                    .zIndex(0)
                Rectangle()
                    .frame(width: CGFloat(progress) * geo.size.width, height: 10)
                    .foregroundColor(color)
                    .animation(.default)
                    .zIndex(2)
            }
            .cornerRadius(5)
        }
        .frame(height: 10)
        .padding(.trailing, 5)
    }
}

struct LinearProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        LinearProgressBar(color: .blue, progress: 0.4)
            .padding(10)
    }
}
