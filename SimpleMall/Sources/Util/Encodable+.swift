//
//  Encodable+.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let dic = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return [:]
        }
        return dic
    }
}
