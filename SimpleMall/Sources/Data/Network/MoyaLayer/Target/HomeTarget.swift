//
//  HomeTarget.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/24.
//

import Foundation
import Moya

enum HomeTarget {
    case home
    case goods(lastId: Int)
}

extension HomeTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://d2bab9i9pr8lds.cloudfront.net/api")!
    }
    
    var path: String {
        switch self {
        case .home: return "/home"
        case .goods: return "/home/goods"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .home: return .get
        case .goods: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .home:
            return .requestPlain
        case .goods(let lastId):
            return .requestParameters(
                parameters: ["lastId": lastId],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

