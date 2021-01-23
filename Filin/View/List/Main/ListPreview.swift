//
//  ListPreview.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/01.
//

import SwiftUI

struct ListPreview: View {
    
    @Binding var isAddSheet: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Group {
                    HabitRow(habit: FlHabit(
                        name: "A ten-minute walk".localized,
                        numberOfTimes: 3, requiredSec: 600
                    ), showAdd: true)
                    HabitRow(habit: FlHabit(name: "Stretching".localized), showAdd: true)
                }
                .opacity(0.5)
                .disabled(true)
                Text("Set goals and execute them.".localized)
                    .bodyText()
                    .padding(.top, 34)
                MainRectButton(action: { isAddSheet = true }, str: "Add new goal".localized)
                    .padding(.top, 13)
            }
        }
        .padding(.top, 1)
    }
}

struct ListPreview_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(isAddSheet: .constant(false))
    }
}
