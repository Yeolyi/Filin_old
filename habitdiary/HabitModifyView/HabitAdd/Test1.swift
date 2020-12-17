//
//  Test1.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct Test1: View {
    
    let color: Color
    @Binding var name: String
    @EnvironmentObject var sharedViewData: SharedViewData
    @FetchRequest(
        entity: HabitInfo.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<HabitInfo>
    
    var body: some View {
        VStack {
            Image(systemName: "text.badge.checkmark")
                .font(.system(size: 70, weight: .semibold))
                .foregroundColor(color)
                .padding(.bottom, 10)
                .padding(.top, 70)
            Text("\(sharedViewData.isFirstRun && habitInfos.isEmpty ? "첫번째" : "새로운") 습관 만들기")
                .font(.system(size: 30, weight: .bold))
                .padding(.bottom, 100)
            HStack {
                Text("제목")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.leading, 20)
                Spacer()
            }
            TextField("물 다섯잔 마시기", text: $name)
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

struct Test1_Previews: PreviewProvider {
    static var previews: some View {
        Test1(color: .blue, name: .constant(""))
    }
}
