//
//  NotificationModel.swift
//  iOSNotifications
//
//  Created by John Lima on 18/06/17.
//  Copyright © 2017 jlima. All rights reserved.
//

import UIKit

struct NotificationModel: Codable {
    
    let id: Int
    let aps: Aps
    
    struct Aps: Codable {
        
        let mutableContent: Int
        let category: String
        let attachment: String
        let alert: Alert
        
        struct Alert: Codable {
            let title: String
            let subtitle: String
            let body: String
        }
        
        private enum CodingKeys: String, CodingKey {
            case category
            case attachment
            case alert
            case mutableContent = "mutable-content"
        }
    }
}

extension NotificationModel {
    
    struct Keys {
        static let id = "id"
        static let attachment = "attachment"
    }
    
    static func getModel(from: Data) -> NotificationModel? {
        let decoder = JSONDecoder()
        let model = try? decoder.decode(NotificationModel.self, from: from)
        return model
    }
    
    static func getModel(from: JSON) -> NotificationModel? {
        guard let data = try? JSONSerialization.data(withJSONObject: from, options: .prettyPrinted) else { return nil }
        return getModel(from: data)
    }
    
    static func getData() -> [NotificationModel]? {
        
        guard let data = UserDefaults.standard.object(forKey: Constants.DataKey.savedNotifications) as? Data, let notifications = NSKeyedUnarchiver.unarchiveObject(with: data) as? [JSON], notifications.count > 0 else { return nil }
        
        var results = [NotificationModel]()
        
        for notification in notifications {
            guard let model = getModel(from: notification) else { continue }
            results.append(model)
        }
        
        return results
    }
    
    static func save(json: JSON) {
        
        var json = json
        
        func removeDuplicates(in array: [JSON]) -> [JSON] {
            var result = [JSON]()
            var array = array
            array.append(json)
            for item in array {
                let ids = result.map({ $0[Keys.id] as? Int ?? -1 }).filter({ $0 > 0 })
                if !ids.contains(item[Keys.id] as? Int ?? 0) {
                    result.append(item)
                }
            }
            return result
        }
        
        func save(array: [JSON]) {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            UserDefaults.standard.set(data, forKey: Constants.DataKey.savedNotifications)
            UserDefaults.standard.synchronize()
        }
        
        guard let data = UserDefaults.standard.object(forKey: Constants.DataKey.savedNotifications) as? Data, var array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [JSON], array.count > 0 else {
            json[Keys.id] = Int.generateUniqueId(array: nil, key: Keys.id)
            save(array: [json])
            return
        }
        
        json[Keys.id] = Int.generateUniqueId(array: array, key: Keys.id)
        
        array = removeDuplicates(in: array)
        save(array: array)
    }
    
    static func remove(byId: Int) {
        
    }
    
    static func remove(byIds: [Int]) {
        for id in byIds {
            remove(byId: id)
        }
    }
}
