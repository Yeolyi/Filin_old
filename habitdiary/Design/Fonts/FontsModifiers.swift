//
//  FontsModifiers.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/17.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
                .font(.system(size: 30, weight: .heavy))
            Spacer()
        }
    }
}

extension View {
    func title() -> some View {
        return modifier(Title())
    }
}

/// Substitutes SwiftUI list section header
struct SectionText: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
                .font(.system(size: 21, weight: .bold))
                .padding(.top, 15)
            Spacer()
        }
        .padding(.leading, 20)
    }
}

extension View {
    func sectionText() -> some View {
        return modifier(SectionText())
    }
}

struct RowHeadline: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(ThemeColor.mainColor)
    }
}

extension View {
    func rowHeadline() -> some View {
        return modifier(RowHeadline())
    }
}

struct RowSubheadline: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16))
            .foregroundColor(ThemeColor.mainColor)
    }
}

extension View {
    func rowSubheadline() -> some View {
        return modifier(RowSubheadline())
    }
}
