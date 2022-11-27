//
//  FavoriteViewReactor.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/27.
//

import Foundation

import ReactorKit
import RxSwift

final class FavoriteViewReactor: Reactor {
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case refreshItems([Product])
    }
    
    struct State {
        var favoriteProducts: [Product]
    }
    
    let initialState: State
    
    private let favoriteProductUseCase: FavoriteProductUseCase
    
    init(favoriteProductUseCase: FavoriteProductUseCase) {
        self.initialState = State(favoriteProducts: [])
        self.favoriteProductUseCase = favoriteProductUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return favoriteProductUseCase.products()
                .map { .refreshItems($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .refreshItems(let products):
            newState.favoriteProducts = products
        }
        return newState
    }
}
