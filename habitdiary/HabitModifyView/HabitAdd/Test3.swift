//
//  Test3.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct Test3: View {
    
    @Binding var number: Int
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: "textformat.123")
                .font(.system(size: 80, weight: .semibold))
                .foregroundColor(color)
                .padding(.bottom, 10)
                .padding(.top, 100)
            Text("횟수 설정")
                .font(.system(size: 40, weight: .bold))
                .padding(.bottom, 100)
            HStack {
                Text("횟수")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.leading, 20)
                Spacer()
            }
            Stepper(value: $number, in: 1...20) {
                Text("\(number)회")
                Spacer()
            }
            .rowBackground()
            Spacer()
        }
    }
}

struct Test3_Previews: PreviewProvider {
    static var previews: some View {
        Test3(number: .constant(5), color: .blue)
    }
}
