//
//  Test4.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct ThemeSection: View {
    
    @Binding var color: String
    
    var body: some View {
        HabitAddBadgeView(title: "Theme".localized, imageName: "paintpalette") {
            Text("Color".localized)
                .sectionText()
            ColorHorizontalPicker(selectedColor: $color)
        }
    }
}

struct Test4_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSection(color: .constant(""))
    }
}
