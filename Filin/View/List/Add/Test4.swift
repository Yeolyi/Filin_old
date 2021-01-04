//
//  TimerSection.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/27.
//

import SwiftUI

struct TimerSection: View {
    
    @Binding var minute: Int
    @Binding var second: Int
    @Binding var isRequiredTime: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HabitAddBadgeView(title: "Timer".localized, imageName: "timer") {
            HStack {
                Text("Use a timer if you need a specific time to achieve your goal. E.g. two-minute plank.".localized)
                    .bodyText()
                    .padding(.bottom, 13)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.horizontal, 20)
            HStack {
                Text("Use timer".localized)
                    .bodyText()
                Spacer()
                PaperToggle($isRequiredTime)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            if isRequiredTime {
                TimerPicker(minute: $minute, second: $second)
                    .rowPadding()
            }
        }
    }
}

struct TimerSection_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        
        @State var minute = 1
        @State var second = 30
        @State var isRequiredTime = false
        
        var body: some View {
            TimerSection(minute: $minute, second: $second, isRequiredTime: $isRequiredTime)
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}
