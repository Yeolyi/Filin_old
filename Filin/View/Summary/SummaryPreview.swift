//
//  SummaryPreview.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct SummaryPreview: View {
    
    @Binding var isSettingSheet: Bool
    
    var body: some View {
        RingCalendar(
            selectedDate: .constant(Date()),
            habits: [CoreDataPreview.sampleHabit(name: ""), CoreDataPreview.sampleHabit(name: "")]
        )
        .opacity(0.5)
        .disabled(true)
        Text("See information of goals at once.")
            .bodyText()
            .padding(.top, 34)
        MainRectButton(
            action: { isSettingSheet = true },
            str: "Select goals".localized
        )
        .padding(.top, 13)
    }
}

struct SummaryPreview_Previews: PreviewProvider {
    static var previews: some View {
        SummaryPreview(isSettingSheet: .constant(false))
    }
}
