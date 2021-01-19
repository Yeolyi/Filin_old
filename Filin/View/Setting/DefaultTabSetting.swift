//
//  DefaultTabSetting.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

/// 앱 실행 시 기본 탭 변경하는 설정 뷰
///
/// - Note: AppSetting가 환경 변수로 전달되어야함
struct DefaultTabSetting: View {
    @EnvironmentObject var appSetting: AppSetting
    var body: some View {
        VStack(spacing: 0) {
            ForEach([DefaultTap.list, .routine, .summary], id: \.self) { tapName in
                Button(action: {
                    appSetting.defaultTap = tapName.rawValue
                }) {
                    HStack {
                        Text(tapName.string)
                            .bodyText()
                        Spacer()
                        if tapName.rawValue == appSetting.defaultTap {
                            Image(systemName: "checkmark")
                                .bodyText()
                        }
                    }
                    .rowBackground()
                }
            }
            Spacer()
        }
        .navigationBarTitle(Text("Change Default Tab".localized))
    }
}

struct DefaultTabSetting_Previews: PreviewProvider {
    static var previews: some View {
        DefaultTabSetting()
            .environmentObject(AppSetting())
    }
}
