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
    
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()
    
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
                .map { [weak self] banners, products in
                    let favorites = self?.fetchFavorite() ?? []
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
                return productUseCase
                    .products(lastID: lastID)
                    .map { [weak self] products in
                        let favorites = self?.fetchFavorite() ?? []
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
                    saveFavorite(product: product)
                    return .just(.updateFavoriteProducts(product, isFavorite))
                    // TODO: UseCase&DataLayer 미구현 시 emit 없어 Mutation이 없음, 구현 후 복구
//                    favoriteProductUseCase
//                        .save(product: product)
//                        .map { Mutation.updateFavoriteProducts(product, isFavorite) }
                } else {
                    deleteFavorite(product: product)
                    return .just(.updateFavoriteProducts(product, isFavorite))
//                    favoriteProductUseCase
//                        .delete(product: product)
//                        .map { Mutation.updateFavoriteProducts(product, isFavorite) }
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
            newState.nextProducts = products
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
    
    // TODO: 찜 관련 메서드&로직 Data layer로 이동, 추상화 하여 UserDefaults & CoreData 로 영속성 구현
    
    private func fetchFavorite() -> [Product] {
        guard let data = UserDefaults.Favorite.object(forKey: .products) as? Data,
              let products = try? decoder.decode([Product].self, from: data)
        else { return [] }
        print(#function)
        dump(products)
        return products
    }
    
    private func updateFavorite(_ products: [Product]) {
        let encoded = try? encoder.encode(products)
        UserDefaults.Favorite.set(value: encoded, forKey: .products)
    }
    
    private func saveFavorite(product: Product) {
        var newP = product
        newP.isFavorite = true
        var products = fetchFavorite()
        if products.filter({ $0.id == newP.id }).isEmpty {
            products.append(newP)
            updateFavorite(products)
        }
    }
    
    private func deleteFavorite(product: Product) {
        let oldProducts = fetchFavorite()
        let newProducts = oldProducts.filter { $0.id != product.id }
        updateFavorite(newProducts)
    }
}
