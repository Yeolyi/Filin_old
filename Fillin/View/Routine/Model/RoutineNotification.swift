//
//  RoutineNotification.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI
import UserNotifications

enum NotificationError: Error {
    case error
}

class RoutineNotiManager {
    static func add(id: UUID, name: String, date: Date, dayOfWeek: [Int], completion: @escaping (Bool) -> Void) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                let content = UNMutableNotificationContent()
                content.title = name
                content.body = "Time to start routine.".localized
                
                // Configure the recurring date.
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                dateComponents.hour = date.hour
                dateComponents.minute = date.minute
                
                for dayOfWeekComp in dayOfWeek {
                
                    dateComponents.weekday = dayOfWeekComp

                    // Create the trigger as a repeating event.
                    let trigger = UNCalendarNotificationTrigger(
                        dateMatching: dateComponents, repeats: true
                    )

                    // Create the request
                    let uuidString = id.uuidString + String(dayOfWeekComp)
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
    static func delete(id: UUID) {
        var idList: [String] = []
        for dayOfWeek in [1, 2, 3, 4, 5, 6, 7].map({String($0)}) {
            idList.append(id.uuidString + dayOfWeek)
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idList)
    }
}
