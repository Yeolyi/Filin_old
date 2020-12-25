//
//  RoutineProfile.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

struct RoutineProfile: Codable {
    var id = UUID()
    var name: String
    var list: [UUID]
}
