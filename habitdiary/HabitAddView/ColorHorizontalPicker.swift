//
//  ColorHorizontalPicker.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct ColorHorizontalPicker: View {
    
    @Binding var selectedColor: Color
    let colorList: [Color] = [.black, .blue, .red, .pink, .green, .orange]
    
    var body: some View {
        HStack {
            ForEach(colorList, id: \.self) { color in
                ZStack {
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 40, height: 40)
                        .padding(5)
                    if selectedColor == color {
                        Image(systemName: "checkmark")
                            .foregroundColor(color)
                            .colorInvert()
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedColor = color
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
