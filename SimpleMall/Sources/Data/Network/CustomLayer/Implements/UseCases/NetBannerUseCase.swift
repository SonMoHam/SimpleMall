//
//  NetBannerUseCase.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation
import RxSwift

/// Network - BannerUseCase 구현체
final class NetBannerUseCase {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}


extension NetBannerUseCase: BannerUseCase {
    func banners() -> Observable<[Banner]> {
        let endpoint = HomeEndpoints.getHome()
        return Observable.create { [weak self] observer -> Disposable in
            self?.networkService.request(with: endpoint) { result in
                switch result {
                case .success(let decodable):
                    observer.onNext(decodable.banners)
                case .failure(let error):
                    print(error.localizedDescription)
                    // TODO: error 보내기 위해 타입 수정??
                    observer.onNext([])
                }
            }
            return Disposables.create()
        }
    }
}


final class StubBannerUseCase: BannerUseCase {
    func banners() -> Observable<[Banner]> {
        let dummyBanners: [Banner] = [
            Banner(id: 1,imageURL: "list.bullet"),
            Banner(id: 2, imageURL: "person.fill")
        ]
        return Observable.create { observer -> Disposable in
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                observer.onNext(dummyBanners)
            }
            return Disposables.create()
        }
    }
}
