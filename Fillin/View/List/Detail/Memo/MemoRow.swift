//
//  DiaryRow.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct MemoRow: View {
    @Binding var activeSheet: DetailViewActiveSheet?
    @ObservedObject var habit: Habit
    @Environment(\.colorScheme) var colorScheme
    let selectedDate: Date
    var body: some View {
        Button(action: { self.activeSheet = DetailViewActiveSheet.diary }) {
            VStack {
                if habit.memo[selectedDate.dictKey] != nil {
                    HStack {
                        Text(habit.memo[selectedDate.dictKey]!)
                            .font(.system(size: 18))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(3)
                            .foregroundColor(ThemeColor.mainColor(colorScheme))
                        Spacer()
                    }
                } else {
                    HStack {
                        Text("Tap to open note".localized)
                            .font(.system(size: 18))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(3)
                            .foregroundColor(ThemeColor.mainColor(colorScheme))
                        Spacer()
                    }
                }
            }
            .padding(.top, 5)
            .rowBackground()
        }
    }
}

/*
struct DiaryRow_Previews: PreviewProvider {
    static var previews: some View {
        DiaryRow()
    }
}
*/
