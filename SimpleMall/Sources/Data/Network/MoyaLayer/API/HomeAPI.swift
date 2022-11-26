//
//  HomeAPI.swift
//  SimpleMall
//
//  Created by 손대홍 on 2022/11/26.
//

import Foundation

import Moya
import RxMoya
import RxSwift

public class HomeAPI {
    let disposeBag = DisposeBag()
    
    let provider: MoyaProvider<HomeTarget> = .init()
    
    func home() -> Observable<HomeResponseDTO> {
        return provider.rx.request(.home)
            .asObservable()
            .map(HomeResponseDTO.self)
            .catchAndReturn(HomeResponseDTO(banners: [], goods: []))
    }
}
