//
//  UseCaseProvider.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation

public protocol UseCaseProdiver {
    func makeBannerUseCase() -> BannerUseCase
    func makeProductUseCase() -> ProductUseCase
    func makeFavoriteProductUseCase() -> FavoriteProductUseCase
}
