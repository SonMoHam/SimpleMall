//
//  AFNetworkService.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Alamofire

public final class AFNetworkService : NetworkService {
    public func request<R, E>(
        with endpoint: E,
        completion: @escaping (Result<R, Error>) -> Void
    ) where R : Decodable, R == E.Response, E : Requestable {
        guard let urlRequest = endpoint.asURLRequest() else {
            completion(.failure(NetworkError.urlGeneration))
            return
        }
        AF.request(urlRequest)
            .responseDecodable(of: R.self) { response in
                switch response.result {
                case .success(let decodable):
                    dump(decodable)
                    completion(.success(decodable))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
