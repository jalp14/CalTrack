//
//  GetPermission.swift
//  CalTrack
//
//  Created by Jalp on 24/04/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Foundation
import SwiftUI

// **************** Class requests notification and sets the trigger **************** \\
class GetPermission {
    static let shared = GetPermission()
    init(){}
    
    // Request Notification Access
    func requestNotificationAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Approved!")
                UserDefaults.standard.set(true, forKey: "isNotificationsAllowed")
                self.setNotificationrigger()
            } else if let error = error {
                print(error.localizedDescription)
                UserDefaults.standard.set(false, forKey: "isNotificationsAllowed")
            }
        }
    }
    // Set the notification to trigger every 24 hours
    func setNotificationrigger() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Goal Reminder"
        content.subtitle = "Don't forget to set your goal for today"
        content.sound = UNNotificationSound.default
        
        var dateInterval = DateComponents()
        dateInterval.hour = 24
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInterval, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
}
