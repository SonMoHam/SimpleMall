//
//  HomeViewReactor.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/26.
//

import Foundation

import ReactorKit
import RxSwift

final class HomeViewReactor: Reactor {
    enum Action {
        case refresh
        case pagination(
            contentHeight: CGFloat,
            contentOffsetY: CGFloat,
            scrollViewHeight: CGFloat
        )
        case didTapFavorite(goodsID: Int, isFavorite: Bool)
    }
    
    enum Mutation {
        case refreshItems([Banner], [Product])
        case appendNextProducts([Product])
        case updateFavoriteProducts(Product, Bool)
    }
    
    struct State {
        var banners: [Banner]
        var products: [Product]
        var isRefresh: Bool = true
    }
    
    let initialState: State
    
    private let bannerUseCase: BannerUseCase
    private let productUseCase: ProductUseCase
    private let favoriteProductUseCase: FavoriteProductUseCase
    
    init(
        bannerUseCase: BannerUseCase,
        productUseCase: ProductUseCase,
        favoriteProductUseCase: FavoriteProductUseCase
    ) {
        self.bannerUseCase = bannerUseCase
        self.productUseCase = productUseCase
        self.favoriteProductUseCase = favoriteProductUseCase
        self.initialState = State(banners: [], products: [])
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable
                .combineLatest(
                    bannerUseCase.banners(),
                    productUseCase.products(),
                    favoriteProductUseCase.products())
                .map { banners, products, favorites in
                    let mutated = products.map { product in
                        var newP = product
                        newP.isFavorite = !(favorites.filter { $0.id == product.id }.isEmpty)
                        return newP
                    }
                    return Mutation.refreshItems(banners, mutated)
                }
            
        case let .pagination(contentHeight, contentOffsetY, scrollViewHeight):
            if contentHeight - scrollViewHeight < contentOffsetY,
               let lastID = currentState.products.last?.id
            {
                return Observable
                    .combineLatest(
                        productUseCase.products(lastID: lastID),
                        favoriteProductUseCase.products())
                    .map { products, favorites in
                        let mutated = products.map { product in
                            var newP = product
                            newP.isFavorite = !(favorites.filter { $0.id == product.id }.isEmpty)
                            return newP
                        }
                        return Mutation.appendNextProducts(mutated)
                    }
            } else {
                return .empty()
            }
            
        case let .didTapFavorite(goodsID, isFavorite):
            if let product = currentState.products.filter({ $0.id == goodsID }).first {
                if isFavorite {
                    return favoriteProductUseCase
                        .save(product: product)
                        .map { Mutation.updateFavoriteProducts(product, isFavorite) }
                } else {
                    return favoriteProductUseCase
                        .delete(product: product)
                        .map { Mutation.updateFavoriteProducts(product, isFavorite) }
                }
            } else {
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .refreshItems(banners, products):
            newState.banners = banners
            newState.products = products
            newState.isRefresh = true
            
        case .appendNextProducts(let products):
            newState.products += products
            newState.isRefresh = false
            
        case let .updateFavoriteProducts(product, newValue):
            let newProducts = newState.products.map {
                var newP = $0
                newP.isFavorite = (product.id == newP.id) ? newValue : newP.isFavorite
                return newP
            }
            newState.products = newProducts
            newState.isRefresh = false
        }
        
        return newState
    }
}
