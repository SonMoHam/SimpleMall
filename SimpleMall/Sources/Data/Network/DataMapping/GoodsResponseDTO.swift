//
//  GoodsResponseDTO.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation

struct GoodsResponseDTO: Decodable {
    let goods: [Product]
}
