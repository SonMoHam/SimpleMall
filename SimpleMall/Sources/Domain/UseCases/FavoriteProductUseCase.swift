//
//  FavoriteProductUseCase.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation
import RxSwift

public protocol FavoriteProductUseCase {
    func products() -> Observable<[Product]>
    func save(product: Product) -> Observable<Void>
    func delete(product: Product) -> Observable<Void>
}
