//
//  HabitShare.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/19.
//

import SwiftUI

struct HabitShare: View {
    
    let habit: HabitContext
    
    init(habit: HabitContext) {
        self.habit = habit
    }
    
    var calendarImage: UIImage {
        RingCalendar(true, selectedDate: .constant(Date()), isExpanded: true, habit1: habit)
            .environmentObject(AppSetting())
            .asImage()
    }
    
    var body: some View {
        ScrollView {
            RingCalendar(true, selectedDate: .constant(Date()), habit1: habit)
                .environmentObject(AppSetting())
                .padding(10)
            VStack(spacing: 0) {
                Button(action: {
                    share(items: [calendarImage])
                }) {
                    HStack {
                        Spacer()
                        Text("Share".localized)
                            .bodyText()
                        Spacer()
                    }
                    .rowBackground()
                }
                Button(action: {
                    SharingHandler.instagramStory(imageData: calendarImage.pngData()!)
                }) {
                    HStack {
                        Spacer()
                        Text("Instagram Story".localized)
                            .bodyText()
                        Spacer()
                    }
                    .rowBackground()
                }
            }
            .padding(.top, 1)
        }
    }
}

@discardableResult
func share(
    items: [Any],
    excludedActivityTypes: [UIActivity.ActivityType]? = nil
) -> Bool {
    guard let source = UIApplication.shared.windows.last?.rootViewController else {
        return false
    }
    let vc = UIActivityViewController(
        activityItems: items,
        applicationActivities: nil
    )
    vc.excludedActivityTypes = excludedActivityTypes
    vc.popoverPresentationController?.sourceView = source.view
    source.present(vc, animated: true)
    return true
}

struct HabitShare_Previews: PreviewProvider {
    static var previews: some View {
        HabitShare(habit: HabitContext.sample1)
            .environmentObject(AppSetting())
    }
}
