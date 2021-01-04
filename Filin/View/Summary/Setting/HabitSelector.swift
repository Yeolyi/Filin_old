//
//  HabitSelector.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct HabitSelector: View {
    
    let position: Int
    @Binding var ringName: String
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(habitInfos, id: \.self) { habit in
                    Button(action: {
                        summary[0].setByNumber(position, id: habit.id)
                        ringName = habitInfos.first(where: {$0.id == habit.id})?.name ?? ""
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(habit.name)
                                .mainColor()
                                .bodyText()
                            Spacer()
                            if summary[0].getByNumber(position) == habit.id {
                                Image(systemName: "checkmark")
                                    .mainColor()
                                    .bodyText()
                            }
                        }
                    }
                    .rowBackground()
                }
                Button(action: {
                    summary[0].setByNumber(position, id: nil)
                    ringName = "Empty".localized
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
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
        entity: Summary.entity(),
        sortDescriptors: []
    )
    var summary: FetchedResults<Summary>
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    @Environment(\.managedObjectContext) var managedObjectContext
    
}
