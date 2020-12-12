//
//  ColorGauge.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//

import SwiftUI

struct HabitGauge: View {
    
    let color: Color
    let times: Int16
    let achieve: Int16
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle().frame(width: 150 , height: 10)
                .foregroundColor(color.opacity(0.1))
            Rectangle().frame(width: percentAchieved * 150, height: 10)
                .foregroundColor(color.opacity(0.5))
                .animation(.default)
        }
        .cornerRadius(45.0)
        .padding(.trailing, 10)
    }
    
    var percentAchieved: CGFloat {
        guard times > 0 else {
            return 1.0
        }
        return min(CGFloat(achieve)/CGFloat(times), 1)
    }
    
}
