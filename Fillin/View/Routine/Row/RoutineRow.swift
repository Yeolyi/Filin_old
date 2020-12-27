//
//  RoutineRow.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct RoutineRow: View {
    
    @ObservedObject var routine: Routine
    @Binding var isSheet: RoutineSheet?
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var displayManager: DisplayManager
    
    var subTitle: String {
        var subTitleStr = ""
        if routine.dayOfWeek.count != 7 {
            for dayOfWeekInt16 in routine.dayOfWeek {
                subTitleStr += "\(Date.dayOfTheWeekStr(Int(dayOfWeekInt16))), "
            }
            _ = subTitleStr.popLast()
            _ = subTitleStr.popLast()
        } else {
            subTitleStr = "Every day".localized
        }
        if let time = routine.time {
            let timeStr = Date(hourAndMinuteStr: time)
            subTitleStr += " \(timeStr.localizedHourMinute)"
        }
        subTitleStr += ", \(String(format: NSLocalizedString("%d goals", comment: ""), routine.list.count))"
        return subTitleStr
    }
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(routine.name)
                        .rowHeadline()
                    Spacer()
                }
                HStack {
                    Text(subTitle)
                        .rowSubheadline()
                    Spacer()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isSheet = .edit(routine)
            }
            Spacer()
            NavigationLink(destination:
                RunRoutine(routine: routine)
            ) {
                Image(systemName: "play")
                    .font(.system(size: 22, weight: .semibold))
                    .mainColor()
                    .frame(width: 50, height: 60)
            }
        }
        .padding(.leading, 10)
        .padding([.top, .bottom], 3)
        .rowBackground()
    }
}

/*
 struct RoutineRow_Previews: PreviewProvider {
 static var previews: some View {
 RoutineRow()
 }
 }
 */
