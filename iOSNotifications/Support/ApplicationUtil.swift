//
//  ApplicationUtil.swift
//  iOSNotifications
//
//  Created by John Lima on 22/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    static func openSettings(type: Constants.SettingsType? = nil) {
        DispatchQueue.main.async {
            guard let url = URL(string: type != nil ? (type?.rawValue ?? UIApplicationOpenSettingsURLString) : UIApplicationOpenSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
