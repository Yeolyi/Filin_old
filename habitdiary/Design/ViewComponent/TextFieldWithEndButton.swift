//
//  TextFieldWithEndButton.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct TextFieldWithEndButton: View {
    let titleKey: String
    @Binding var text: String
    @Environment(\.colorScheme) var colorScheme
    init(_ titleKey: String, text: Binding<String>) {
        self.titleKey = titleKey
        self._text = text
    }
    var body: some View {
        HStack {
            TextField(titleKey, text: $text)
            Button(action: {UIApplication.shared.endEditing()}) {
                Text("확인")
                    .foregroundColor(ThemeColor.mainColor(colorScheme))
            }
        }
        .rowBackground()
    }
}
