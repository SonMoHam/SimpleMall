//
//  UDFavoriteProductUseCase.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation
import RxSwift

/// Persistent - UserDefaults FavoriteProductUseCase
final class UDFavoriteProductUseCase { }

/* TODO: 채택, 준수 구현
extension UDFavoriteProductUseCase: FavoriteProductUseCase {
    func products() -> RxSwift.Observable<[Product]> {
        <#code#>
    }
    
    func save(product: Product) -> RxSwift.Observable<Void> {
        <#code#>
    }
    
    func delete(product: Product) -> RxSwift.Observable<Void> {
        <#code#>
    }
}
*/

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
