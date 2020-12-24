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
        "#f07264", "#f5ad60", "#83d378", "#5996f8", "#b57ddf", "#a5a5a5", "FCAFC0"
    ]
    static func mainColor(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? mainLight : mainDark
    }
    static func subColor(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? subLight : subDark
    }
}
