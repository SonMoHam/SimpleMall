//
//  RMProduct.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/27.
//

import Foundation
import RealmSwift

final class RMProduct: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var actualPrice: Int = 0
    @objc dynamic var price: Int = 0
    @objc dynamic var isNew: Bool = false
    @objc dynamic var sellCount: Int = 0
    @objc dynamic var isFavorite: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
