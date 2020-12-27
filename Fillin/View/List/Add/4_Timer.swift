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
        ScrollView {
        HabitAddBadgeView(title: "Timer".localized, imageName: "timer") {
                Text("Use a timer if you need a specific time to achieve your goal. E.g. two-minute plank.".localized)
                    .rowHeadline()
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Toggle("", isOn: $isRequiredTime)
                    .toggleStyle(
                        ColoredToggleStyle(
                            label: "Use timer".localized,
                            onColor: ThemeColor.mainColor(colorScheme)
                        )
                    )
                    .padding(.horizontal, 10)
                if isRequiredTime {
                    GeometryReader { geo in
                        HStack {
                            VStack {
                                Picker(selection: $minute, label: EmptyView(), content: {
                                    ForEach(0...59, id: \.self) { minute in
                                        Text(String(minute))
                                            .rowHeadline()
                                    }
                                })
                                .frame(height: 170)
                                .frame(maxWidth: geo.size.width/2 - 10)
                                .clipped()
                                Text("Minute")
                                    .rowSubheadline()
                            }
                            VStack {
                                Picker(selection: $second, label: EmptyView(), content: {
                                    ForEach(0...59, id: \.self) { second in
                                        Text(String(second))
                                            .rowHeadline()
                                    }
                                })
                                .frame(height: 170)
                                .frame(maxWidth: geo.size.width/2 - 10)
                                .clipped()
                                Text("Second")
                                    .rowSubheadline()
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .frame(height: 200)
                }
            }
        }
    }
}

/*
 struct TimerSection_Previews: PreviewProvider {
 static var previews: some View {
 TimerSection()
 }
 }
 */
