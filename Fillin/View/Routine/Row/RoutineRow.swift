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
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(routine.name)
                        .rowHeadline()
                    Spacer()
                }
                HStack {
                    Text("\(routine.list.count)개의 목표로 구성됨")
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
