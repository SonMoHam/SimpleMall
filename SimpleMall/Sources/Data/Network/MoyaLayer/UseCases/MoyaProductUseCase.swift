//
//  MoyaProductUseCase.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/26.
//

import Moya
import RxSwift

final class MoyaProductUseCase {
    private let networkService: HomeAPI
    
    init(networkService: HomeAPI) {
        self.networkService = networkService
    }
}


extension MoyaProductUseCase: ProductUseCase {
    func products(lastID: Int) -> RxSwift.Observable<[Product]> {
        return networkService.goods(lastID: lastID)
            .map { $0.goods }
    }
    
    func products() -> Observable<[Product]> {
        return networkService.home()
            .map { $0.goods }
    }
}
