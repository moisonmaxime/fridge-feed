//
//  UserSettings.swift
//  Lynx
//
//  Created by Maxime Moison on 10/24/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

class UserSettings {
    
    static var isLoggedIn: Bool {
        return accessKey != nil
    }
    
    static var accessKey: String? {
        get {
            return get(.accessKey) as? String
        }
        set {
            set(key: .accessKey, value: newValue)
        }
    }
    
    static func logout() {
        clear()
    }
    
    static func clear() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
        }
    }
}





private extension UserSettings {
    enum UserSettingKey: String {
        case accessKey = "access_tokey"
        case userInformation = "user_info"
    }
    
    static func set(key: UserSettingKey, value: Any?) {
        if let newValue = value {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        } else {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        UserDefaults.standard.synchronize()
    }
    
    static func get(_ key: UserSettingKey) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
}
