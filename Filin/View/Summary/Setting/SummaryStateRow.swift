//
//  SummaryStateRow.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct SummaryStateRow: View {
    
    let num: Int
    @Binding var ringName: String
    
    var description: String {
        switch num {
        case 1:
            return "Habit 1(Outermost ring)".localized
        case 2:
            return "Habit 2".localized
        case 3:
            return "Habit 3(Innermost ring)".localized
        default:
            assertionFailure()
            return "First ring".localized
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text(description)
                    .bodyText()
                    .mainColor()
                Spacer()
                Text(ringName)
                    .subColor()
                    .bodyText()
            }
            NavigationLink(destination: HabitSelector(position: num, ringName: $ringName)) {
                Rectangle()
                    .opacity(0)
            }
        }
        .rowBackground()
    }
}


struct SummaryStateRow_Previews: PreviewProvider {
    static var previews: some View {
        SummaryStateRow(num: 1, ringName: .constant(""))
    }
}

