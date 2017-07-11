//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by John Lima on 20/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var attachmentImageView: UIImageView!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func didReceive(_ notification: UNNotification) {
        
        titleLabel.text = notification.request.content.title
        subtitleLabel.text = notification.request.content.subtitle
        bodyLabel.text = notification.request.content.body
        
        guard let attachment = notification.request.content.attachments.first else { return }
        guard let attachmentData = try? Data(contentsOf: attachment.url) else { return }
        
        attachmentImageView.image = UIImage(data: attachmentData)
    }
}
