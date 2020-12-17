//
//  ColorHorizontalPicker.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI



struct ColorHorizontalPicker: View {
    
    @Binding var selectedColor: String
    var colorList: [String] = ["#D95555", "#F2784B", "#A6886D", "#F2C335", "#50BF77", "#89C7B6", "#8DA6A3", "#1D79F2", "#737EBF", "#BF889C"]
    let rowButtonNum: Int
    let rowCount: Int
    let buttonSize: CGFloat = 40.0
    let buttonPadding: CGFloat = 5.0
    let sidePadding: CGFloat = 40.0
    
    init(selectedColor: Binding<String>) {
        self._selectedColor = selectedColor
        rowButtonNum = Int(Double((UIScreen.main.bounds.size.width - sidePadding*2 + buttonPadding)/(buttonSize+buttonPadding)))
        rowCount = Int(ceil(Double(colorList.count) / Double(rowButtonNum)))
        colorList = colorList.sorted(by: {Color(hex: $0).uiColor().hue < Color(hex: $1).uiColor().hue})
        //print(colorList)
    }
    
    func button(index: Int) -> AnyView {
        
        AnyView (
            Button(action: {
                self.selectedColor = colorList[index]
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(Color(hex: colorList[index]))
                        .frame(width: buttonSize, height: buttonSize)
                        .padding(buttonPadding)
                        .zIndex(0)
                    if selectedColor == colorList[index] {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: colorList[index]))
                            .brightness(0.2)
                            .zIndex(1)
                    }
                }
            }
        )
    }
    
    func rowView(rowNum: Int) -> AnyView {
        AnyView(
            HStack(spacing: 0) {
                if rowNum == rowCount - 1 {
                    ForEach(0..<(colorList.count - rowButtonNum * rowNum), id: \.self) { columnNum in
                        button(index: rowButtonNum*rowNum+columnNum)
                    }
                    ForEach(0..<(rowButtonNum - (colorList.count - rowButtonNum * rowNum)), id: \.self) { columnNum in
                        Circle()
                            .hidden()
                            .frame(width: buttonSize, height: buttonSize)
                            .padding(buttonPadding)
                    }
                } else {
                    ForEach(0..<rowButtonNum, id: \.self) { columnNum in
                        button(index: rowButtonNum*rowNum+columnNum)
                    }
                }
            }
        )
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 0) {
                ForEach(0..<rowCount, id: \.self) { rowNum in
                    rowView(rowNum: rowNum)
                }
            }
            Spacer()
        }
        .rowBackground()
        .padding([.leading, .trailing], 10)
    }
    
}

struct ColorHorizontalPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorHorizontalPicker(selectedColor: .constant(""))
    }
}

