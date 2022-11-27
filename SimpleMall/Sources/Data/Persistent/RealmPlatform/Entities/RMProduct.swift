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

extension RMProduct: DomainConvertible {
    func toDomain() -> Product {
        return Product(
            id: id,
            name: name,
            imageURL: imageURL,
            actualPrice: actualPrice,
            price: price,
            isNew: isNew,
            sellCount: sellCount,
            isFavorite: isFavorite)
    }
    
    func uID() -> Int {
        return id
    }
}

extension Product: RealmConvertible {
    func toRealm() -> RMProduct {
        let object = RMProduct()
        object.id = id
        object.name = name
        object.imageURL = imageURL
        object.actualPrice = actualPrice
        object.price = price
        object.isNew = isNew
        object.sellCount = sellCount
        object.isFavorite = isFavorite ?? false
        return object
    }
}
