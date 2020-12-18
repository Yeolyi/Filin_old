//
//  Test4.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct Test4: View {
    
    @Binding var color: String
    
    var body: some View {
        VStack {
            Image(systemName: "paintbrush")
                .font(.system(size: 70, weight: .semibold))
                .foregroundColor(Color(hex: color))
                .padding(.bottom, 10)
                .padding(.top, 70)
            Text("테마 색 설정")
                .title()
                .padding(.bottom, 100)
            Text("색")
                .sectionText()
            ColorHorizontalPicker(selectedColor: $color)
            Spacer()
        }
    }
}

struct Test4_Previews: PreviewProvider {
    static var previews: some View {
        Test4(color: .constant(""))
    }
}
