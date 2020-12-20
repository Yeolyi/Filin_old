//
//  Test3.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct TimesSection: View {
    @Binding var number: String
    var body: some View {
        HabitAddBadgeView(title: "횟수 설정", imageName: "textformat.123") {
            Text("횟수")
                .sectionText()
            TextFieldWithEndButton("15회", text: $number)
                .keyboardType(.numberPad)
            .padding([.leading, .trailing], 10)
        }
        //.keyboardTouchAreaBackground()
    }
}

struct Test3_Previews: PreviewProvider {
    static var previews: some View {
        TimesSection(number: .constant("15"))
    }
}
