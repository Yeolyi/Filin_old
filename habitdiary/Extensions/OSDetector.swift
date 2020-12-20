//
//  OSDetector.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

var isMacOS: Bool {
    #if targetEnvironment(macCatalyst)
    return true
    #else
    return false
    #endif
}
