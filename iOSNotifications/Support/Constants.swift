//
//  Constants.swift
//  iOSNotifications
//
//  Created by John Lima on 12/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import UIKit
import Foundation

typealias JSON = [String: Any]

struct Constants {
    
    struct Texts {
        static let allowNotification = "I need your permission to send you some notifications 😏"
        static let failedToRegisterNotifications = "⚠️ Failed to register notifications"
        static let deviceToken = "📱 Device Token"
        static let permissionGranted = "Permission granted"
        static let emptyData = "No data"
    }
    
    struct Colors {
        static let defaultApp = UIColor.purple
    }
    
    struct Timer {
        static let goSettings: TimeInterval = 5
    }
    
    struct DataKey {
        static let notificationToken = "KEY_TOKEN"
        static let savedNotifications = "KEY_NOTIFICATIONS"
    }
    
    struct Notification {
        static let registerToken = "RegisterToken"
        static let receiveRemoteNotification = "ReceiveRemoteNotification"
    }
    
    enum SettingsType: String {
        case notifications = "App-Prefs:root=NOTIFICATIONS_ID"
    }
}
