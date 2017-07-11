//
//  AppDelegate.swift
//  iOSNotifications
//
//  Created by John Lima on 12/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var nfmanager = NFManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .default
        
        nfmanager.registerNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        nfmanager.didRegisterForRemoteNotifications(with: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        nfmanager.didFailToRegisterForRemoteNotifications(with: error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        nfmanager.didReceiveRemoteNotification(userInfo: userInfo)
    }
}

