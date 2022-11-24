//
//  NetProductUseCase.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation
import RxSwift

/// Network - ProductUseCase 구현체
final class NetProductUseCase { }

/* TODO: 채택, 준수 구현
extension NetProductUseCase: ProductUseCase {
    func products() -> RxSwift.Observable<[Product]> {
        <#code#>
    }
    
    func products(lastID: Int) -> RxSwift.Observable<[Product]> {
        <#code#>
    }
}
 */

final class StubProductUseCase: ProductUseCase {
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
    
    func products(lastID: Int) -> Observable<[Product]> {
        let dummyNextProducts: [Product] = [
            Product(
                id: 3,
                name: "third",
                imageURL: "person.fill",
                actualPrice: 300,
                price: 30,
                isNew: false,
                sellCount: 8),
            Product(
                id: 4,
                name: "fourth",
                imageURL: "person.fill",
                actualPrice: 400,
                price: 40,
                isNew: false,
                sellCount: 12)
        ]
        return Observable.create { observer -> Disposable in
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                observer.onNext(dummyNextProducts)
            }
            return Disposables.create()
        }
    }
}
