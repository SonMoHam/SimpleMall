//
//  RealmFavoriteProductStorage.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/27.
//

import Foundation

final class RealmFavoriteProductStorage {
    private let realmManager: RealmManager<Product>
    
    init() {
        self.realmManager = RealmManager<Product>()
    }
}
    

extension RealmFavoriteProductStorage: FavoriteProductStorage {
    func products() -> Result<[Product], Error> {
        return realmManager.fetchAll()
    }
    
    func save(product: Product) -> Result<Void, Error> {
        return realmManager.save(entity: product)
    }
    
    func delete(product: Product) -> Result<Void, Error> {
        return realmManager.delete(entity: product)
    }
}
