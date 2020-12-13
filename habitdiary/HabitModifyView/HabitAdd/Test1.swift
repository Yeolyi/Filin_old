//
//  Test1.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct Test1: View {
    
    @Binding var color: Color
    @Binding var name: String
    @Binding var habitExplain: String
    
    var body: some View {
        VStack {
            Image(systemName: "square.dashed")
                .font(.system(size: 80, weight: .semibold))
                .foregroundColor(color)
                .padding(.bottom, 10)
                .padding(.top, 100)
            Text("새로운 습관 만들기")
                .font(.system(size: 40, weight: .bold))
                .padding(.bottom, 100)
            HStack {
                Text("제목")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.leading, 20)
                Spacer()
            }
            TextField("물 다섯잔 마시기", text: $name)
                .rowBackground()
            HStack {
                Text("설명(선택)")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.leading, 20)
                Spacer()
            }
            TextField("하루 2L씩 마시기", text: $habitExplain)
                .rowBackground()
            Spacer()
        }
    }
}

struct Test1_Previews: PreviewProvider {
    static var previews: some View {
        Test1(color: .constant(.blue), name: .constant(""), habitExplain: .constant(""))
    }
}
