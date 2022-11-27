//
//  UserDefaultsFavoriteProductStorage.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/27.
//

import Foundation

final class UserDefaultsFavoriteProductStorage {
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }
    
    private func fetchFavorite() -> [Product] {
        guard let data = UserDefaults.Favorite.object(forKey: .products) as? Data,
              let products = try? decoder.decode([Product].self, from: data)
        else { return [] }
        return products
    }
    
    private func updateFavorite(_ products: [Product]) {
        let encoded = try? encoder.encode(products)
        UserDefaults.Favorite.set(value: encoded, forKey: .products)
    }
}

extension UserDefaultsFavoriteProductStorage: FavoriteProductStorage {
    // ???: 이미 있는 등의 경우 error 반환 할 건지
    
    func products() -> Result<[Product], Error> {
        let products = fetchFavorite()
        return .success(products)
    }
    
    func save(product: Product) -> Result<Void, Error> {
        var newP = product
        newP.isFavorite = true
        var products = fetchFavorite()
        if products.filter( {$0.id == newP.id }).isEmpty {
            products.append(newP)
            updateFavorite(products)
        }
        return .success
    }
    
    func delete(product: Product) -> Result<Void, Error> {
        let products = fetchFavorite()
        let newProducts = products.filter { $0.id != product.id }
        updateFavorite(newProducts)
        return .success
    }
}
