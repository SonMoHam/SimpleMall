//
//  NetUseCaseProvider.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation

final class NetUseCaseProvider {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension NetUseCaseProvider: UseCaseProdiver {
    func makeBannerUseCase() -> BannerUseCase {
        return NetBannerUseCase(networkService: networkService)
    }
    
    func makeProductUseCase() -> ProductUseCase {
        return NetProductUseCase(networkService: networkService)
    }
    
    func makeFavoriteProductUseCase() -> FavoriteProductUseCase {
        return StubFavoriteProductUseCase()
    }
}
