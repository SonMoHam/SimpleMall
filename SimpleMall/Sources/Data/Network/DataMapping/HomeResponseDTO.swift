//
//  HomeResponseDTO.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation

struct HomeResponseDTO: Decodable {
    let banners: [Banner]
    let goods: [Product]
}
