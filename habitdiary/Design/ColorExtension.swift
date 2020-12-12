//
//  ColorExtension.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

extension Color {
    var string: String {
        switch(self) {
        case .blue:
            return "blue"
        case .green:
            return "green"
        case .gray:
            return "gray"
        case .orange:
            return "orange"
        case .pink:
            return "pink"
        case .purple:
            return "purple"
        case .red:
            return "red"
        case .yellow:
            return "yellow"
        default:
            return "black"
        }
    }
}

extension Color {
    init(str: String?) {
        switch(str!) {
        case "blue":
            self = Color.blue
        case "green":
            self = Color.green
        case "gray":
            self = Color.gray
        case "orange":
            self = .orange
        case "pink":
            self = .pink
        case "purple":
            self = .purple
        case "red":
            self = .red
        case "yellow":
            self = .yellow
        default:
            self = Color.black
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
