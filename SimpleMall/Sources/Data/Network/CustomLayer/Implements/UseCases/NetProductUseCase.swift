//
//  NetProductUseCase.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation
import RxSwift

/// Network - ProductUseCase 구현체
final class NetProductUseCase {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}


extension NetProductUseCase: ProductUseCase {
    func products() -> Observable<[Product]> {
        let endpoint = HomeEndpoints.getHome()
        return Observable.create { [weak self] observer -> Disposable in
            self?.networkService.request(with: endpoint) { result in
                switch result {
                case .success(let decodable):
                    observer.onNext(decodable.goods)
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onNext([])
                }
            }
            return Disposables.create()
        }
    }
    
    func products(lastID: Int) -> Observable<[Product]> {
        let endpoint = HomeEndpoints.getGoods(lastId: lastID)
        return Observable.create { [weak self] observer -> Disposable in
            self?.networkService.request(with: endpoint) { result in
                switch result {
                case .success(let decodable):
                    observer.onNext(decodable)
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onNext([])
                }
            }
            return Disposables.create()
        }
    }
}
 

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
