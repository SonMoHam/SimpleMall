//
//  HomeNavigator.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation
import UIKit

class HomeNavigator {
    private let services: UseCaseProdiver
    private let navigationController: UINavigationController
    
    init(services: UseCaseProdiver, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func toHome() {
        let moyaProvider = MoyaUseCaseProvider()
        let homeViewReactor = HomeViewReactor(
            bannerUseCase: moyaProvider.makeBannerUseCase(),
            productUseCase: moyaProvider.makeProductUseCase(),
            favoriteProductUseCase: moyaProvider.makeFavoriteProductUseCase())
        let vc = HomeViewController(reactor: homeViewReactor)
        navigationController.pushViewController(vc, animated: true)
    }
    
    /*
    func toBanner(_ banner: Banner) {
        ...
        navigationController.present(vc, animated: true)
    }
    
    func toProduct(_ product: Product) {
        ...
        navigationController.pushViewController(vc, animated: true)
    }
     */
}
