//
//  NFManager.swift
//  iOSNotifications
//
//  Created by John Lima on 12/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

class NFManager {
    
    func registerNotifications(target: AnyObject? = nil, completion: ((UNAuthorizationStatus) -> ())? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("\(NSLocalizedString(Constants.Texts.permissionGranted, comment: "")): \(granted)")
            guard let target = target else {
                guard granted else { return }
                self.registerForNotifications()
                return
            }
            self.getNotificationSettings(target: target, completion: completion)
        }
    }
    
    func notificationSettings(completion: ((UNAuthorizationStatus) -> ())? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            completion?(settings.authorizationStatus)
        }
    }
    
    func registerForNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    private func getNotificationSettings(target: AnyObject?, completion: ((UNAuthorizationStatus) -> ())? = nil) {
        notificationSettings { (status) in
            switch status {
            case .denied:
                AlertUtil.showBanner(
                    with: NSLocalizedString(Constants.Texts.allowNotification, comment: ""),
                    and: target,
                    and: Constants.Timer.goSettings,
                    completion: { UIApplication.openSettings() }
                )
            case .authorized:
                self.registerForNotifications()
            default:
                break
            }
            completion?(status)
        }
    }
}

// MARK: - Push Notifications
extension NFManager {
    
    func didRegisterForRemoteNotifications(with deviceToken: Data) {
        
        let tokenParts = deviceToken.map { (data) -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        
        UserDefaults.standard.set(token, forKey: Constants.DataKey.notificationToken)
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: Constants.Notification.registerToken),
            object: nil
        )
    }
    
    func didFailToRegisterForRemoteNotifications(with error: Error) {
        print("\(NSLocalizedString(Constants.Texts.failedToRegisterNotifications, comment: "")): \(error)")
    }
    
    func didReceiveRemoteNotification(userInfo: [AnyHashable : Any]) {
        
        guard let info = userInfo as? JSON else { return }
        
        print("notification: \(info)")
        
        NotificationModel.save(json: info)
        
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: Constants.Notification.receiveRemoteNotification),
            object: nil
        )
    }
}
