//
//  LongPressButton.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct LongPressButton: View {
    let imageSystemName: String
    let onTapFunc: () -> Void
    let longTapFunc: () -> Void
    @State var isTapping = false
    var body: some View {
        if isMacOS {
            Button(action: onTapFunc) {
                Image(systemName: imageSystemName)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color(hex: "#404040"))
                    .frame(width: 50, height: 60)
            }
        } else {
            Image(systemName: imageSystemName)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Color(hex: "#404040"))
                .frame(width: 50, height: 60)
                .onTapGesture {
                   onTapFunc()
                }
                .onLongPressGesture(
                    minimumDuration: 0.4,
                    pressing: { isPressing in
                        self.isTapping = isPressing
                    },
                    perform: {
                        longTapFunc()
                    }
                )
                .opacity(isTapping ? 0.5 : 1.0)
        }
    }
}

/*
struct LongPressButton_Previews: PreviewProvider {
    static var previews: some View {
        LongPressButton()
    }
}
*/
