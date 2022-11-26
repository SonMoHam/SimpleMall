//
//  MoyaBannerUseCase.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/26.
//

import Moya
import RxSwift

final class MoyaBannerUseCase {
    private let networkService: HomeAPI
    
    init(networkService: HomeAPI) {
        self.networkService = networkService
    }
}


extension MoyaBannerUseCase: BannerUseCase {
    func banners() -> Observable<[Banner]> {
        return networkService.home()
            .map { $0.banners }
    }
}
