//
//  ColorHorizontalPicker.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct ColorHorizontalPicker: View {
    @Binding var selectedColor: String
    let rowButtonNum: Int
    let rowCount: Int
    let buttonSize: CGFloat = 40.0
    let buttonPadding: CGFloat = 5.0
    let sidePadding: CGFloat = 40.0
    let accentColors = ThemeColor.colorList.sorted(by: {Color(hex: $0).uiColor().hue < Color(hex: $1).uiColor().hue})
    init(selectedColor: Binding<String>) {
        self._selectedColor = selectedColor
        let pickerWidth = UIScreen.main.bounds.size.width - sidePadding*2 + buttonPadding
        rowButtonNum = Int(pickerWidth/(buttonSize+buttonPadding))
        rowCount = Int(ceil(Double(ThemeColor.colorList.count) / Double(rowButtonNum)))
        //print(accentColors)
    }
    var body: some View {
        //ScrollView(.horizontal, showsIndicators: false) {
        HStack {
            ForEach(accentColors, id: \.self) { color in
                Button(action: { self.selectedColor = color }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color(hex: color))
                            .frame(width: 40, height: 40)
                            .zIndex(0)
                        if selectedColor == color {
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
        .padding([.leading, .trailing], 10)
    }
    func button(index: Int) -> some View {
        Button(action: { self.selectedColor = accentColors[index] }) {
            ZStack {
                Circle()
                    .foregroundColor(Color(hex: accentColors[index]))
                    .frame(width: buttonSize, height: buttonSize)
                    .padding(buttonPadding)
                    .zIndex(0)
                if selectedColor == accentColors[index] {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: accentColors[index]))
                        .brightness(0.2)
                        .zIndex(1)
                }
            }
        }
    }
    func rowView(rowNum: Int) -> some View {
        HStack(spacing: 0) {
            if rowNum != rowCount - 1 {
                ForEach(0..<rowButtonNum, id: \.self) { columnNum in
                    button(index: rowButtonNum*rowNum+columnNum)
                }
            } else {
                ForEach(0..<(accentColors.count - rowButtonNum * rowNum), id: \.self) { columnNum in
                    button(index: rowButtonNum*rowNum+columnNum)
                }
                ForEach(0..<(rowButtonNum - (accentColors.count - rowButtonNum * rowNum)), id: \.self) { _ in
                    Circle()
                        .hidden()
                        .frame(width: buttonSize, height: buttonSize)
                        .padding(buttonPadding)
                }
            }
        }
    }
}

struct ColorHorizontalPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorHorizontalPicker(selectedColor: .constant(""))
    }
}
