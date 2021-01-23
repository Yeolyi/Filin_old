//
//  PaperToggle.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct PaperToggle: View {
    
    @Binding var isOn: Bool
    
    init(_ isOn: Binding<Bool>) {
        self._isOn = isOn
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                isOn.toggle()
            }
        }) {
            Image(systemName: isOn ? "checkmark.circle" : "xmark.circle")
                .mainColor()
                .font(.system(size: 24, weight: .semibold))
        }
        .frame(width: 44)
    }
}

struct PaperToggle_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        @State var isOn = false
        var body: some View {
            PaperToggle($isOn)
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}
