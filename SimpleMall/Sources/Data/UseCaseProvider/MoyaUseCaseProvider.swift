//
//  MoyaUseCaseProvider.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/26.
//

import Foundation

final class MoyaUseCaseProvider {
    private let networkService: HomeAPI
    
    init() {
        self.networkService = HomeAPI()
    }
}

extension MoyaUseCaseProvider: UseCaseProdiver {
    func makeBannerUseCase() -> BannerUseCase {
        return MoyaBannerUseCase(networkService: networkService)
    }
    
    func makeProductUseCase() -> ProductUseCase {
        return MoyaProductUseCase(networkService: networkService)
    }
    
    func makeFavoriteProductUseCase() -> FavoriteProductUseCase {
        return UDFavoriteProductUseCase()
    }
}
