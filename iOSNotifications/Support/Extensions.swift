//
//  Extensions.swift
//  iOSNotifications
//
//  Created by John Lima on 12/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import UIKit
import Foundation

extension UIDevice {
    static func isiPAD() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

extension UIBarButtonItem {
    
    func hidden() {
        self.tintColor = .clear
        self.isEnabled = false
    }
    
    func show(color: UIColor = #colorLiteral(red: 0.1091378406, green: 0.6490935683, blue: 0.423900485, alpha: 1)) {
        self.tintColor = color
        self.isEnabled = true
    }
}

extension Int {
    
    /// Use this function to create a unique id
    ///
    /// - Parameters:
    ///   - array: The existed json array.
    ///   - key: The id of json must be int, because if not, it not work
    /// - Returns: The new id result
    static func generateUniqueId(array: [JSON]?, key: String?) -> Int {
        
        var result = Int()
        
        func checkingExistedAndGetUniqueNumber(array: [JSON]?, key: String?, completion: ((Int) -> ())?) {
            var unique = Int()
            func checking() {
                if let array = array, array.count > 0 {
                    var e = [Int]()
                    unique += 1
                    for item in array {
                        if let key = key, let value = item[key] as? Int {
                            e.append(value)
                        }
                    }
                    if e.count < 1 {
                        unique = 1
                        completion?(unique)
                    }else {
                        let existed = e.contains(unique)
                        if existed {
                            checking()
                        }else {
                            completion?(unique)
                        }
                    }
                }else {
                    unique = 1
                    completion?(unique)
                }
            }
            checking()
        }
        
        checkingExistedAndGetUniqueNumber(array: array, key: key) { (unique) -> () in
            result = unique
        }
        
        return result
    }
}
