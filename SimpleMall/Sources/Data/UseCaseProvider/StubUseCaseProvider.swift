//
//  StubUseCaseProvider.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation

final class StubUseCaseProvider: UseCaseProdiver {
    func makeBannerUseCase() -> BannerUseCase {
        return StubBannerUseCase()
    }
    
    func makeProductUseCase() -> ProductUseCase {
        return StubProductUseCase()
    }
    
    func makeFavoriteProductUseCase() -> FavoriteProductUseCase {
        return StubFavoriteProductUseCase()
    }
}
