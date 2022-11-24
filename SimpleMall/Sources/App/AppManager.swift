//
//  AppManager.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation
import UIKit

class AppManager {
    static let shared = AppManager(useCaseProvider: NetUseCaseProvider())
    
    private let networkUseCaseProvider: UseCaseProdiver
    
    private init(useCaseProvider: UseCaseProdiver) {
        networkUseCaseProvider = useCaseProvider
    }
    
    func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func configureMainInterface(in window: UIWindow?) {
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"))
        
        let homeNavigator = HomeNavigator(
            services: networkUseCaseProvider,
            navigationController: homeNavigationController)
        
        let favoriteNavigationController = UINavigationController()
        favoriteNavigationController.tabBarItem = UITabBarItem(
            title: "좋아요",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill"))
        
        let favoriteNavigator = FavoriteNavigator(
            services: networkUseCaseProvider,
            navigationController: favoriteNavigationController)
        
        // TODO: main tab으로 분리
        
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .systemBackground
        tabBarController.setViewControllers(
            [homeNavigationController, favoriteNavigationController],
            animated: false)
        tabBarController.tabBar.backgroundColor = .systemGray5
        tabBarController.tabBar.tintColor = .red
        window?.rootViewController = tabBarController
        
        homeNavigator.toHome()
        favoriteNavigator.toFavorite()
    }
}
