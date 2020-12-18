//
//  Test3.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct Test3: View {
    
    @Binding var number: String
    @Binding var oneTouchUnit: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: "textformat.123")
                .font(.system(size: 70, weight: .semibold))
                .foregroundColor(color)
                .padding(.bottom, 10)
                .padding(.top, 70)
            Text("횟수 설정")
                .title()
                .padding(.bottom, 100)
            Text("횟수")
                .sectionText()
            HStack {
                TextField("15회", text: $number)
                    .keyboardType(.numberPad)
            }
            .rowBackground()
            .padding([.leading, .trailing], 10)
            Spacer()
        }
        .paperBackground()
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct Test3_Previews: PreviewProvider {
    static var previews: some View {
        Test3(number: .constant("15"), oneTouchUnit: .constant("5"), color: .blue)
    }
}
