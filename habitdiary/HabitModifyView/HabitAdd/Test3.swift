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
                .font(.system(size: 30, weight: .bold))
                .padding(.bottom, 100)
            HStack {
                Text("횟수")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.leading, 20)
                Spacer()
            }
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
            endEditing()
        }
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
}

struct Test3_Previews: PreviewProvider {
    static var previews: some View {
        Test3(number: .constant("15"), oneTouchUnit: .constant("5"), color: .blue)
    }
}
