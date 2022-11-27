//
//  DomainConvertible.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/27.
//

import Foundation

protocol DomainConvertible {
    associatedtype DomainEntity
    
    func toDomain() -> DomainEntity
}
