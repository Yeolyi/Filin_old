//
//  ThemeColor.swift
//  FoodLuxMea
//
//  Created by Seong Yeol Yi on 2020/08/23.
//

import SwiftUI

/// Provides title and icon color based on ColorScheme.
class ThemeColor: ObservableObject {
    
    static var mainColor = Color(hex: "#404040")
    static var secondaryColor = Color(hex: "#BFBEBD")
    
    private var titleDark = Color(hex: "#6F77A6")
    private var titleLight = Color(hex: "#3B568C")
    
    private var iconLight = Color(hex: "#3F4D59")
    private var iconDark = Color(hex: "#7B848C")
    
    func icon(_ colorScheme: ColorScheme) -> Color {
        iconLight
        //colorScheme == .dark ? iconDark : iconLight
    }
    
    func title(_ colorScheme: ColorScheme) -> Color {
        titleLight//colorScheme == .dark ? titleDark : titleLight
    }
    
}
