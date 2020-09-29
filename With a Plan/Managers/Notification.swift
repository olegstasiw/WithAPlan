//
//  Notification.swift
//  With a Plan
//
//  Created by mac on 20.09.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {

    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization(completionOn: @escaping () -> (), completion: @escaping () -> ()) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Permission granted: \(granted)")
                completionOn()
            }  else {
                completion()
            }
            guard granted else { return }
            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }

    func scheduleNotification(notifaicationType: String, task: Task) {

        let content = UNMutableNotificationContent()
        let userAction = "User Action"

        content.title = notifaicationType
        content.body = "Your reminder: " + notifaicationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction

        let reminderDate = task.reminder

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let identifire = task.id
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(
            identifier: userAction,
            actions: [deleteAction],
            intentIdentifiers: [],
            options: [])

        notificationCenter.setNotificationCategories([category])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {

        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Delete":
            UIApplication.shared.applicationIconBadgeNumber = 0
        default:
            print("Unknown action")
        }

        completionHandler()
    }
}
