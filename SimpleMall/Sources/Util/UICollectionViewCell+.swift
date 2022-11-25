//
//  UICollectionViewCell+.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/25.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
