//
//  NotificationService.swift
//  NotificationService
//
//  Created by John Lima on 22/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let content = self.bestAttemptContent, let stringFileURL = content.userInfo[NotificationModel.Keys.attachment] as? String, let fileURL = URL(string: stringFileURL), let attachment = try? UNNotificationAttachment(identifier: "image", url: fileURL, options: nil) else { contentHandler(self.bestAttemptContent ?? UNMutableNotificationContent()); return }
        
        content.attachments = [attachment]
        contentHandler(content)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = self.contentHandler, let bestAttemptContent =  self.bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
