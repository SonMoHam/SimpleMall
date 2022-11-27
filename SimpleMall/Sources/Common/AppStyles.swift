//
//  AppStyles.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/26.
//

import UIKit

enum AppStyles {
    enum Color {
        static let textPrimary = UIColor.black
        static let textSecondary = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)
        static let customPink = UIColor(red: 236/255, green: 94/255, blue: 101/255, alpha: 1)
    }
    
    enum Font {
        static let title = UIFont.boldSystemFont(ofSize: 16)
        static let medium = UIFont.systemFont(ofSize: 14)
        static let small = UIFont.systemFont(ofSize: 12)
    }
    
    enum Image {
        static let heart = UIImage(systemName: "heart")
        static let heartFill = UIImage(systemName: "heart.fill")
        static let house = UIImage(systemName: "house")
        static let houseFill = UIImage(systemName: "house.fill")
    }
}
