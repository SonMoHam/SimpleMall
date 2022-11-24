//
//  NetBannerUseCase.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation
import RxSwift

/// Network - BannerUseCase 구현체
final class NetBannerUseCase { }

/* TODO: 채택, 준수 구현
extension NetBannerUseCase: BannerUseCase {
    func banners() -> Observable<[Banner]> {
        <#code#>
    }
}
*/

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
