//
//  MainNavigator.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation
import UIKit

class MainNavigator {
    private let services: UseCaseProdiver
    private let tabBarController: UITabBarController
    
    init(services: UseCaseProdiver, tabBarController: UITabBarController) {
        self.services = services
        self.tabBarController = tabBarController
    }
    
    func toMain() {
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "홈",
            image: AppStyles.Image.house,
            selectedImage: AppStyles.Image.houseFill)
        
        let homeNavigator = HomeNavigator(
            services: services,
            navigationController: homeNavigationController)
        
        let favoriteNavigationController = UINavigationController()
        favoriteNavigationController.tabBarItem = UITabBarItem(
            title: "좋아요",
            image: AppStyles.Image.heart,
            selectedImage: AppStyles.Image.heartFill)
        
        let favoriteNavigator = FavoriteNavigator(
            services: services,
            navigationController: favoriteNavigationController)

        tabBarController.view.backgroundColor = .systemBackground
        tabBarController.setViewControllers(
            [homeNavigationController, favoriteNavigationController],
            animated: false)
        tabBarController.tabBar.tintColor = AppStyles.Color.customPink
        tabBarController.tabBar.isTranslucent = false
        homeNavigationController.navigationBar.isTranslucent = false
        favoriteNavigationController.navigationBar.isTranslucent = false
        homeNavigator.toHome()
        favoriteNavigator.toFavorite()
    }
}
