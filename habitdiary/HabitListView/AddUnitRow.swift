//
//  AddUnitRow.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/15.
//

import SwiftUI

struct AddUnitRow: View {
    let habitID: UUID
    @EnvironmentObject var addUnit: IncrementPerTap
    func selectorButton(_ value: Int) -> some View {
        Button(action: {
            self.addUnit.addUnit[habitID] = value
        }) {
        Text("±\(value)")
            .foregroundColor(addUnit.addUnit[habitID] == value ? .black : .gray)
            .font(.system(size: 25, weight: .light))
            .rowBackground()
        }
    }
    var body: some View {
        HStack(spacing: 3) {
            Spacer()
            selectorButton(1)
            selectorButton(5)
            selectorButton(10)
            selectorButton(20)
            selectorButton(25)
        }
    }
}

struct AddUnitRow_Previews: PreviewProvider {
    static var previews: some View {
        AddUnitRow(habitID: UUID())
    }
}
