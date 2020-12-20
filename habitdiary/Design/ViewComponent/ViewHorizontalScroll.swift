//
//  ViewHorizontalScroll.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct ViewHorizontalScroll<Content: View>: View {
    let content: Content
    @Binding var currentPage: Int
    let totalPage: Int
    var offSet: CGFloat {
        let canvasSize = UIScreen.main.bounds.width * CGFloat(totalPage)
        return (canvasSize-UIScreen.main.bounds.width)/2 - CGFloat(currentPage - 1) * UIScreen.main.bounds.width
    }
    init(currentPage: Binding<Int>, totalPage: Int, @ViewBuilder content: @escaping () -> Content) {
        self._currentPage = currentPage
        self.totalPage = totalPage
        self.content = content()
    }
    var body: some View {
        HStack(spacing: 0) {
            content
        }
        .offset(x: offSet)
    }
}

/*
struct ViewHorizontalScroll_Previews: PreviewProvider {
    static var previews: some View {
        ViewHorizontalScroll()
    }
}
*/
