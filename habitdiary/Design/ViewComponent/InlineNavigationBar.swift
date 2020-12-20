//
//  InlineNavigationBar.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct InlineNavigationBar<Content1: View, Content2: View>: View {
    let title: String
    let button1: Content1
    let button2: Content2?
    init(title: String, @ViewBuilder button1: @escaping () -> Content1, button2: (() -> Content2)? = nil) {
        self.title = title
        self.button1 = button1()
        self.button2 = button2?()
    }
    var body: some View {
            VStack {
                HStack {
                    Text(title)
                        .title()
                        .padding(.leading, 20)
                    Spacer()
                    if button2 != nil {
                        button2!
                    }
                    button1
                }
                Divider()
            }
    }
}

/*
struct InlineNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        InlineNavigationBar()
    }
}
*/
