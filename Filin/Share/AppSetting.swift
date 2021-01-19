//
//  SharedViewDagta.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

class AppSetting: ObservableObject {
    
    @AutoSave("runCount", defaultValue: 0)
    var runCount: Int
    @AutoSave("defaultTap", defaultValue: 0)
    var defaultTap: Int {
        didSet {
            objectWillChange.send()
        }
    }
    @AutoSave("mondayCalendar", defaultValue: false)
    var isMondayStart: Bool {
        didSet {
            objectWillChange.send()
        }
    }
    /// 다음 날 정보를 보여줄 시간 설정. 시간 단위. 기본값 0(24시)
    @AutoSave("dayResetTime", defaultValue: 0)
    var dayResetTime: Int {
        didSet {
            objectWillChange.send()
        }
    }
    var isFirstRun: Bool {
        runCount == 1
    }
    var mainDate: Date {
        if Date().hour >= dayResetTime {
            return Date()
        } else {
            return Date().addDate(-1)!
        }
    }
}
