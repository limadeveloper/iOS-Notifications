//
//  HomeTableViewCell.swift
//  iOSNotifications
//
//  Created by John Lima on 22/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var label: UILabel!
    
    var data: NotificationModel? {
        didSet {
            guard let data = data else {
                label.text = NSLocalizedString(Constants.Texts.emptyData, comment: "")
                label.textAlignment = .center
                accessoryType = .none
                return
            }
            label.text = """
                \(data.id). \(data.aps.alert.title)
            """
            label.textAlignment = .left
            accessoryType = .disclosureIndicator
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
