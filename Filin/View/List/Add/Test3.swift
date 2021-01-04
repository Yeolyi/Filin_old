//
//  Test3.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct TimesSection: View {
    
    @Binding var number: Int
    @Binding var oneTapUnit: Int
    @State var isSet = false
    @State var setNum = 1
    
    var setNumWrapper: Binding<Int> {
        Binding(
            get: { setNum },
            set: {
                setNum = $0
                number = setNum * oneTapUnit
            }
        )
    }
    var oneTapWrapper: Binding<Int> {
        Binding(
            get: { oneTapUnit },
            set: {
                oneTapUnit = $0
                number = setNum * oneTapUnit
            }
        )
    }
    var isSetWrapper: Binding<Bool> {
        Binding(
            get: { isSet },
            set: {
                if $0 {
                    oneTapUnit = number
                    setNum = 1
                } else {
                    number = oneTapUnit * setNum
                }
                isSet = $0
            }
        )
    }
    
    var body: some View {
        HabitAddBadgeView(title: "Number of times".localized, imageName: "clock.arrow.2.circlepath") {
            Group {
                HStack {
                    Text("Split into sets".localized)
                        .bodyText()
                    Spacer()
                    PaperToggle(isSetWrapper)
                }
                if !isSet {
                    PickerWithButton(str: "How many times do you want to achieve your goal in a day?".localized, size: 100, number: $number)
                } else {
                    PickerWithButton(str: "How many times do you proceed in one set?".localized, size: 100, number: oneTapWrapper)
                    PickerWithButton(str: "How many sets are there?".localized, size: 30, number: setNumWrapper)
                    Divider()
                    Text("Total: \(number)")
                        .headline()
                }
            }
            .rowPadding()
        }
    }
}

struct Test3_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        
        @State var number = 10
        @State var oneTapUnit = 1
        
        var body: some View {
            TimesSection(number: $number, oneTapUnit: $oneTapUnit)
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}
