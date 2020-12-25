//
//  DefaultTabSetting.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

struct DefaultTabSetting: View {
    @EnvironmentObject var appSetting: AppSetting
    var body: some View {
        VStack {
            ForEach(DefaultTap.allCases, id: \.self) { tapName in
                Button(action: {
                    appSetting.defaultTap = tapName.rawValue
                }) {
                    HStack {
                        Text(tapName.string)
                            .rowHeadline()
                        Spacer()
                        if tapName.rawValue == appSetting.defaultTap {
                            Image(systemName: "checkmark")
                                .mainColor()
                        }
                    }
                }
            }
            .rowBackground()
            Spacer()
        }
        .navigationBarTitle(Text("Change default tab".localized))
    }
}

struct DefaultTabSetting_Previews: PreviewProvider {
    static var previews: some View {
        DefaultTabSetting()
    }
}
