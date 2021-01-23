//
//  PreviewCoreDataContext.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/24.
//

import SwiftUI
import CoreData

/// Xcode preview와 앱스토어 스크린샷을 위한 임시 manager들과 데이터들을 제공.
/// - Note: 데이터가 중복으로 저장됨을 막기 위해 싱글톤 패턴 사용.
/// - Todo: 싱글톤 패턴을 꼭 사용해야되는지 생각해보기. 의존성 주입이 뭔지 공부하기.
final class DataSample {
    
    let habitManager = HabitManager.shared
    let summaryManager = SummaryManager.shared
    let routineManager = RoutineManager.shared
    
    static let shared = DataSample()
    
    var habit1: FlHabit {
        habitManager.contents[0]
    }
    var habit2: FlHabit {
        habitManager.contents[1]
    }
    var summary: FlSummary {
        summaryManager.contents[0]
    }
    var routine1: FlRoutine {
        routineManager.contents[0]
    }
    var routine2: FlRoutine {
        routineManager.contents[1]
    }
    
    private init() {
        let habitDatas: [(name: String, color: Color, numberOfTimes: Int, requiredSec: Int)] = [
            ("Stretching".localized, Palette.Default.red.color, 10, 10),
            ("Drink water".localized, Palette.Default.blue.color, 8, 0),
            ("A ten-minute walk".localized, Palette.Default.orange.color, 3, 0),
            ("Vitamins".localized, Palette.Default.purple.color, 3, 0)
        ]
        var usedIds: [UUID] = []
        let habits: [FlHabit] = habitDatas.map { data in
            let id = UUID()
            usedIds.append(id)
            return FlHabit(
                id: id, name: data.name, color: data.color,
                numberOfTimes: data.numberOfTimes, requiredSec: data.requiredSec
            )
        }
        for habit in habits {
            habit.achievement.content = (-60...0).reduce(into: [:], { result, num in
                let newDateKey = Date().addDate(num)!.dictKey
                result[newDateKey] = Int.random(in: 0...habit.achievement.numberOfTimes)
            })
            habitManager.append(habit)
        }
        
        summaryManager.append(.init(id: UUID(), name: "Default"))
        summaryManager.contents[0].first = usedIds[0]
        summaryManager.contents[0].second = usedIds[1]
        
        let routine1 = FlRoutine(UUID(), name: "After wake up".localized)
        routine1.list = Array(habits[0...1])
        let routine2 = FlRoutine(UUID(), name: "Before bed".localized)
        routine2.list = Array(habits[0...3])
        routineManager.append(routine1)
        routineManager.append(routine2)
    }

}
