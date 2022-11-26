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
        var nextProducts: [Product]
        var isRefresh: Bool = false
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
        self.initialState = State(banners: [], products: [], nextProducts: [])
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable
                .combineLatest(bannerUseCase.banners(), productUseCase.products())
                .map { Mutation.refreshItems($0, $1) }
            
        case let .pagination(contentHeight, contentOffsetY, scrollViewHeight):
            if contentHeight - scrollViewHeight < contentOffsetY,
               let lastID = currentState.products.last?.id
            {
                return productUseCase
                    .products(lastID: lastID)
                    .map { Mutation.appendNextProducts($0) }
            } else {
                return .empty()
            }
        case let .didTapFavorite(goodsID, isFavorite):
            // TODO: 찜 관련 로직 작성
            if let product = currentState.products.filter({ $0.id == goodsID }).first {
                return .just(.updateFavoriteProducts(product, isFavorite))
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
            newState.nextProducts = products
            newState.isRefresh = false
            
        case let .updateFavoriteProducts(product, newValue):
            // TODO: 찜 구현
            break
        }
        
        return newState
    }
}
