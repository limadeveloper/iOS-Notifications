//
//  CustomNavigationViewController.swift
//  iOSNotifications
//
//  Created by John Lima on 12/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: Constants.Colors.defaultApp]
        
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: Constants.Colors.defaultApp]
        }
    }
}
