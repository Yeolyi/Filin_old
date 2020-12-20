//
//  ThemeColor.swift
//  FoodLuxMea
//
//  Created by Seong Yeol Yi on 2020/08/23.
//

import SwiftUI

/// Provides title and icon color based on ColorScheme.
class ThemeColor: ObservableObject {
    private static var mainLight = Color(hex: "#404040")
    private static var mainDark = Color(hex: "#BFBFBF")
    private static var subLight = Color(hex: "#BEBEBE")
    private static var subDark = Color(hex: "#414141")
    static var colorList: [String] = [
        "CBCBCB", "#404040", "F7A097", "FBF595", "9ED9A1", "A6ECF2", "92AAD0", "B6A4CC", "F7B0B6"
    ]
    static func mainColor(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? mainLight : mainDark
    }
    static func subColor(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? subLight : subDark
    }
}
