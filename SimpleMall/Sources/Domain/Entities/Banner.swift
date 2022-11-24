//
//  Banner.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation

public struct Banner: Codable {
    /// 배너 ID
    let id: Int

    /// 배너 이미지 url
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image"
    }
}
