//
//  UDFavoriteProductUseCase.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation
import RxSwift

/// Persistent - UserDefaults FavoriteProductUseCase
final class UDFavoriteProductUseCase {
    private let storage: FavoriteProductStorage
    init() {
        storage = UserDefaultsFavoriteProductStorage()
    }
}


extension UDFavoriteProductUseCase: FavoriteProductUseCase {
    func products() -> Observable<[Product]> {
        let result = storage.products()
        return Observable.create { observer -> Disposable in
            switch result {
            case .success(let products):
                observer.onNext(products)
            case .failure(let error):
                print(error.localizedDescription)
            }
            return Disposables.create()
        }
    }
    
    func save(product: Product) -> Observable<Void> {
        let result = storage.save(product: product)
        return Observable.create { observer -> Disposable in
            switch result {
            case .success:
                observer.onNext(())
            case .failure(let error):
                print(error.localizedDescription)
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
    
    func delete(product: Product) -> Observable<Void> {
        let result = storage.delete(product: product)
        return Observable.create { observer -> Disposable in
            switch result {
            case .success:
                observer.onNext(())
            case .failure(let error):
                print(error.localizedDescription)
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
}


final class StubFavoriteProductUseCase: FavoriteProductUseCase {
    func products() -> Observable<[Product]> {
        let dummyProducts: [Product] = [
            Product(
                id: 1,
                name: "first",
                imageURL: "list.bullet",
                actualPrice: 100,
                price: 10,
                isNew: true,
                sellCount: 9),
            Product(
                id: 2,
                name: "second",
                imageURL: "list.bullet",
                actualPrice: 200,
                price: 20,
                isNew: true,
                sellCount: 10)
        ]
        return Observable.create { observer -> Disposable in
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                observer.onNext(dummyProducts)
            }
            return Disposables.create()
        }
    }
    
    func save(product: Product) -> Observable<Void> {
        return Observable.empty()
    }
    
    func delete(product: Product) -> Observable<Void> {
        return Observable.empty()
    }
    
    
}
