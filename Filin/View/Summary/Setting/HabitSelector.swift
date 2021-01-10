//
//  HabitSelector.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct HabitSelector: View {
    
    let position: Int
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Binding var targetHabit: HabitContext?
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(HabitContextManager.shared.contents, id: \.self) { habit in
                    Button(action: {
                        targetHabit = habit
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(habit.name)
                                .mainColor()
                                .bodyText()
                            Spacer()
                            if targetHabit?.id == habit.id {
                                Image(systemName: "checkmark")
                                    .mainColor()
                                    .bodyText()
                            }
                        }
                    }
                    .rowBackground()
                }
                Button(action: {
                    targetHabit = nil
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text("Empty".localized)
                            .mainColor()
                            .bodyText()
                        Spacer()
                    }
                    .rowBackground()
                }
            }
            .padding(.top, 1)
        }
    }
}
