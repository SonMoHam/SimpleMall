//
//  ProductUseCase.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation
import RxSwift

public protocol ProductUseCase {
    func products() -> Observable<[Product]>
    func products(lastID: Int) -> Observable<[Product]>
}
