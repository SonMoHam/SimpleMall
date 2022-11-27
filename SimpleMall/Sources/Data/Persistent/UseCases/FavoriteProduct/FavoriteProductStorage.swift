//
//  FavoriteProductStorage.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/27.
//

import Foundation

public protocol FavoriteProductStorage {
    func products() -> Result<[Product], Error>
    func save(product: Product) -> Result<Void, Error>
    func delete(product: Product) -> Result<Void, Error>
}
