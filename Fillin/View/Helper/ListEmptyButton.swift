//
//  ListEmptyButton.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct ListEmptyButton: View {
    @Environment(\.colorScheme) var colorScheme
    let action: () -> Void
    let str: String
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(str)
                    .foregroundColor(.white)
                    .bodyText()
                    .padding(10)
                Spacer()
            }
        }
        .background(
            Rectangle()
                .foregroundColor(ThemeColor.mainColor(colorScheme))
        )
        .padding([.leading, .trailing], 10)
    }
}

struct ListEmptyButton_Previews: PreviewProvider {
    static var previews: some View {
        ListEmptyButton(action: {}, str: "Add new calendar")
    }
}
