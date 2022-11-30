//
//  Coordinator.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/30.
//

import UIKit

protocol Coordinator {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
