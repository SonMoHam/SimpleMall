//
//  FavoriteNavigator.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation
import UIKit

class FavoriteNavigator {
    private let services: UseCaseProdiver
    private let navigationController: UINavigationController
    
    init(services: UseCaseProdiver, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func toFavorite() {
        let vc = FavoriteViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    /*
    func toProduct(_ product: Product) {
        ...
        navigationController.pushViewController(vc, animated: true)
    }
     */
}
