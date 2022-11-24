//
//  BannerUseCase.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation
import RxSwift

public protocol BannerUseCase {
    func banners() -> Observable<[Banner]>
}
