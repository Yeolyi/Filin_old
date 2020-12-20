//
//  DiaryRow.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct DiaryRow: View {
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var habit: HabitInfo
    @Environment(\.colorScheme) var colorScheme
    let selectedDate: Date
    var body: some View {
        Button(action: { self.activeSheet = ActiveSheet.diary }) {
            VStack {
                if habit.diary[selectedDate.dictKey] != nil {
                    HStack {
                        Text(habit.diary[selectedDate.dictKey]!)
                            .font(.custom("NanumMyeongjoBold", size: 18))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(3)
                            .foregroundColor(ThemeColor.mainColor(colorScheme))
                        Spacer()
                    }
                } else {
                    HStack {
                        Text("탭하여 일기 쓰기")
                            .font(.custom("NanumMyeongjoBold", size: 18))
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
