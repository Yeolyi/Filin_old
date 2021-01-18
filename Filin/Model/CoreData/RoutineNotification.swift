//
//  RoutineNotification.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI
import UserNotifications

extension RoutineContext {
    func addNoti(completion: @escaping (Bool) -> Void) {
        guard let time = self.time else {
            completion(false)
            return
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                let content = UNMutableNotificationContent()
                content.title = self.name
                content.body = "Time to start routine.".localized
                content.sound = UNNotificationSound.default
                
                // Configure the recurring date.
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                dateComponents.hour = time.hour
                dateComponents.minute = time.minute
                
                for dayOfWeekComp in self.dayOfWeek {
                
                    dateComponents.weekday = dayOfWeekComp

                    // Create the trigger as a repeating event.
                    let trigger = UNCalendarNotificationTrigger(
                        dateMatching: dateComponents, repeats: true
                    )

                    // Create the request
                    let uuidString = self.id.uuidString + String(dayOfWeekComp)
                    let request = UNNotificationRequest(
                        identifier: uuidString,
                        content: content,
                        trigger: trigger
                    )
                    
                    // Schedule the request with the system.
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.add(request) { (error) in
                        if error != nil {
                            // Handle any errors.
                            print(error!.localizedDescription)
                            completion(false)
                        }
                        completion(true)
                    }
                }
            } else if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(false)
            }
        }
    }
    func deleteNoti() {
        var idList: [String] = []
        for dayOfWeek in [1, 2, 3, 4, 5, 6, 7].map({String($0)}) {
            idList.append(self.id.uuidString + dayOfWeek)
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idList)
    }
}
