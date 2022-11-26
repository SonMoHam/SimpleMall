//
//  AppManager.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation
import UIKit

class AppManager {
    static let shared = AppManager(useCaseProvider: MoyaUseCaseProvider())
    
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
        let mainTabBarController = UITabBarController()
        let mainNavigator = MainNavigator(
            services: networkUseCaseProvider,
            tabBarController: mainTabBarController)

        window?.rootViewController = mainTabBarController
        
        mainNavigator.toMain()
    }
}
