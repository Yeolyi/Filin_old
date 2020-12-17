//
//  SharedViewDagta.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

class SharedViewData: ObservableObject {
    @Published var inMainView = true
    @AutoSave("runCount", defaultValue: 0)
    var runCount: Int {
        didSet {
            objectWillChange.send()
        }
    }
    var isFirstRun: Bool {
        runCount == 1
    }
}
