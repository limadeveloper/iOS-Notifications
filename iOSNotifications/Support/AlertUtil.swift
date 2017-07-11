//
//  AlertUtil.swift
//  iOSNotifications
//
//  Created by John Lima on 12/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import UIKit
import Foundation

class AlertUtil: NSObject {
    
    private static var timer: Timer?
    private static var banner: UIAlertController?
    private static var action: (() -> ())?
    
    static func createAlert(with title: String?, message: String?, actions: [UIAlertAction], target: AnyObject?, style: UIAlertControllerStyle = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions { alert.addAction(action) }
        DispatchQueue.main.async {
            target?.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showBanner(with message: String, and target: AnyObject?, and timeInterval: TimeInterval, completion: (() -> ())? = nil) {
        self.banner = UIAlertController(title: nil, message: message, preferredStyle: UIDevice.isiPAD() ? .alert : .actionSheet)
        self.action = completion
        guard let banner = banner else { return }
        DispatchQueue.main.async {
            target?.present(banner, animated: true, completion: {
                self.timer = Timer.scheduledTimer(
                    timeInterval: timeInterval,
                    target: self,
                    selector: #selector(hideBanner),
                    userInfo: nil,
                    repeats: false
                )
            })
        }
    }
    
    @objc dynamic private static func hideBanner() {
        DispatchQueue.main.async {
            timer?.invalidate()
            banner?.dismiss(animated: true) { self.action?() }
        }
    }
}
