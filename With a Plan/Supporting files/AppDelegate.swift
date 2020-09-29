//
//  AppDelegate.swift
//  With a Plan
//
//  Created by mac on 19.07.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let notifications = Notifications()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notifications.notificationCenter.delegate = notifications
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
}
