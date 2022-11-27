//
//  Result+.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/27.
//

import Foundation

extension Result where Success == Void {
    public static var success: Result { .success(()) }
}
