//
//  CheckPicker.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

protocol PickerUsable: Hashable {
    var string: String { get }
}

struct CheckPicker<Option: PickerUsable>: View {
    let options: [Option]
    @Environment(\.colorScheme) var colorScheme
    @Binding var selected: Option
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    HStack(spacing: 0) {
                        Image(systemName: selected == option ? "checkmark.square" : "square")
                            .font(.system(size: 25))
                            .foregroundColor(ThemeColor.mainColor(colorScheme))
                            .onTapGesture {
                                selected = option
                            }
                            .padding(.trailing, 3)
                        Text(option.string)
                            .rowHeadline()
                    }
                    .padding(.trailing, 6)
                }
            }
            Spacer()
        }
    }
}

struct CheckPicker_Previews: PreviewProvider {
    static var previews: some View {
        CheckPicker(options: [HabitType.daily, HabitType.weekly], selected: .constant(HabitType.weekly))
    }
}
