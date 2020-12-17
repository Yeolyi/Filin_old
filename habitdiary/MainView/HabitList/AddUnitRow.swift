//
//  AddUnitRow.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/15.
//

import SwiftUI

struct AddUnitRow: View {
    
    let id: UUID
    @EnvironmentObject var addUnit: AddUnit
    
    var body: some View {
        HStack(spacing: 3) {
            Spacer()
            Button(action: {
                self.addUnit.addUnit[id] = 1
            }) {
            Text("±1")
                .foregroundColor(addUnit.addUnit[id] == 1 ? .black : .gray)
                .font(.system(size: 25, weight: .light))
                .rowBackground()
            }
            Button(action: {
                self.addUnit.addUnit[id] = 5
            }) {
            Text("±5")
                .foregroundColor(addUnit.addUnit[id] == 5 ? .black : .gray)
                .font(.system(size: 25, weight: .light))
                .rowBackground()
            }
            Button(action: {
                self.addUnit.addUnit[id] = 10
            }) {
            Text("±10")
                .foregroundColor(addUnit.addUnit[id] == 10 ? .black : .gray)
                .font(.system(size: 25, weight: .light))
                .rowBackground()
            }
        }
    }
}

struct AddUnitRow_Previews: PreviewProvider {
    static var previews: some View {
        AddUnitRow(id: UUID())
    }
}
