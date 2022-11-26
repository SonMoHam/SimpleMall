//
//  UserDefaultsAvailable.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/26.
//

import Foundation

protocol UserDefaultsAvailable {
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsAvailable where defaultKeys.RawValue == String {
    static func set(value: Any?, forKey key: defaultKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func object(forKey key: defaultKeys) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
}
