//
//  HomeEndpoints.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation

struct HomeEndpoints {
    static func getHome() -> Endpoint<HomeResponseDTO> {
        return Endpoint(baseURL: "", path: "/home", method: .get)
    }
    
    static func getGoods(lastId: Int) -> Endpoint<[Product]> {
        return Endpoint(baseURL: "", path: "/home/goods", method: .get)
    }
    // getProducts()
}
