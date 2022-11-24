//
//  HomeEndpoints.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation

// TODO: 이동
let baseURL = "http://d2bab9i9pr8lds.cloudfront.net/api"

struct HomeEndpoints {
    static func getHome() -> Endpoint<HomeResponseDTO> {
        return Endpoint(baseURL: baseURL, path: "/home", method: .get)
    }
    
    static func getGoods(lastId: Int) -> Endpoint<[Product]> {
        return Endpoint(baseURL: baseURL, path: "/home/goods", method: .get)
    }
    // getProducts()
}
