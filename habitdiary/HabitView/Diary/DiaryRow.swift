//
//  DiaryRow.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct DiaryRow: View {
    
    @Binding var activeSheet: ActiveSheet?
    @Binding var expanded: Bool
    @ObservedObject var habit: HabitInfo
    let selectedDate: Date
    
    var body: some View {
        VStack {
            HStack {
                Text("일기")
                    .font(.headline)
                Spacer()
                Button(action: {
                    withAnimation {
                        expanded.toggle()
                    }
                }) {
                    Image(systemName: "square.split.1x2")
                        .font(.system(size: 25, weight: .light))
                        .padding(.trailing, 10)
                }
                Button(action: {activeSheet = ActiveSheet.diary}) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 25, weight: .light))
                }
            }
            if !expanded && habit.diary[selectedDate.dictKey] != nil {
                Text(habit.diary[selectedDate.dictKey]!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                    .foregroundColor(.gray)
                    .padding(8)
            }
            if expanded {
                DiaryExpanded(habit: habit)
            }
        }
        .rowBackground()
    }
}

/*
struct DiaryRow_Previews: PreviewProvider {
    static var previews: some View {
        DiaryRow()
    }
}
*/
