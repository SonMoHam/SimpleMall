//
//  UserDefaultsKeys.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/26.
//

import Foundation

extension UserDefaults {
    public struct Favorite: UserDefaultsAvailable {
        enum defaultKeys: String {
            case products
        }
    }
}
