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
        HabitAddBadgeView(title: "Number of times".localized, imageName: "clock.arrow.2.circlepath") {
            Text("How many times do you want to achieve your goal in a day?".localized)
                .rowHeadline()
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
            TextFieldWithEndButton("15", text: $number)
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
