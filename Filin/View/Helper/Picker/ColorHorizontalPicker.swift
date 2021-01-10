//
//  ColorHorizontalPicker.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct ColorHorizontalPicker: View {
    
    @Binding var selectedColor: Color
    let accentColors = ThemeColor.colorList.sorted(by: {Color(hex: $0).hue < Color(hex: $1).hue})
    
    var body: some View {
        HStack {
            ForEach(accentColors, id: \.self) { color in
                Button(action: { self.selectedColor = Color(hex: color) }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color(hex: color))
                            .frame(width: 40, height: 40)
                            .zIndex(0)
                        if selectedColor == Color(hex: color) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(hex: color))
                                .brightness(0.2)
                                .zIndex(1)
                        }
                    }
                }
            }
        }
    }
}

struct ColorHorizontalPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorHorizontalPicker(selectedColor: .constant(.blue))
    }
}
