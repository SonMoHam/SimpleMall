//
//  RealmConvertible.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/27.
//

import Foundation

protocol RealmConvertible {
    associatedtype RealmEntity: DomainConvertible
    
    func toRealm() -> RealmEntity
}
