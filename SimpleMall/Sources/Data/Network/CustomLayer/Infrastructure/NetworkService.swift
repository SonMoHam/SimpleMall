//
//  NetworkService.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation

public enum NetworkError: Error {
    case urlGeneration
    case responseDecoding
}

public protocol NetworkService {
    func request<R, E>(
        with endpoint: E,
        completion: @escaping (Result<R, Error>) -> Void
    ) where R : Decodable, R == E.Response, E : Requestable
}

extension NetworkService {
    func decode<R: Decodable>(data: Data?) -> Result<R, Error> {
        do {
            guard let data = data else { return .failure(NetworkError.responseDecoding) }
            let decoded: R = try JSONDecoder().decode(R.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(NetworkError.responseDecoding)
        }
    }
}
