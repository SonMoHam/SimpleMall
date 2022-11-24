//
//  HomeEndpoints.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation

struct HomeEndpoints {
    static func getHome() -> Endpoint<HomeResponseDTO> {
        return Endpoint(
            baseURL: "https://d2bab9i9pr8lds.cloudfront.net/api",
            path: "/home",
            method: .get)
    }
    
    static func getGoods(lastId: Int) -> Endpoint<[Product]> {
        return Endpoint(
            baseURL: "https://d2bab9i9pr8lds.cloudfront.net/api",
            path: "/home/goods",
            method: .get,
            queryParameters: ["lastId": lastId] )
    }
}
