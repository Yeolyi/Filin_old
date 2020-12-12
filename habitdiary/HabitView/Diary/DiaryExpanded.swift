//
//  MemoExpanded.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct DiaryExpanded: View {
    @ObservedObject var habit: HabitInfo
    var body: some View {
        VStack {
            ForEach(habit.diary.sorted(by: <), id: \.key) { key, value in
                VStack {
                    HStack {
                        Text(String(key))
                            .padding([.leading, .top], 5)
                            .font(.headline)
                        Spacer()
                    }
                    Text(String(value))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom], 5)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

/*
struct DiaryExpanded_Previews: PreviewProvider {
    static var previews: some View {
        DiaryExpanded()
    }
}
*/
