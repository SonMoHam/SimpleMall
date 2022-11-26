//
//  Product.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation

/// goods
public struct Product: Codable, Hashable {
    /// 상품 ID
    let id: Int
    /// 상품 이름
    let name: String
    /// 상품 이미지 url
    let imageURL: String
    /// 상품 기본 가격
    let actualPrice: Int
    /// 상품 실제 가격 ( 기본가격 X 할인율 / 100 - 실제가격 )
    let price: Int
    /// 신상품 여부
    let isNew: Bool
    /// 구매중 갯수
    let sellCount: Int
    
    var isFavorite: Bool?
    
    init(
        id: Int,
        name: String,
        imageURL: String,
        actualPrice: Int,
        price: Int,
        isNew: Bool,
        sellCount: Int,
        isFavorite: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.actualPrice = actualPrice
        self.price = price
        self.isNew = isNew
        self.sellCount = sellCount
        self.isFavorite = isFavorite
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, price, isFavorite
        case imageURL = "image"
        case actualPrice = "actual_price"
        case isNew = "is_new"
        case sellCount = "sell_count"
    }
    
}
