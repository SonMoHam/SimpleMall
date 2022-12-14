//
//  Endpoint.swift
//  SimpleMall
//
//  Created by Son Daehong on 2022/11/24.
//

import Foundation

public enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    // put ... delete ...
}

public final class Endpoint<R>: Requestable {
    
    
    public typealias Response = R
    
    public let baseURL: String
    public let path: String
    public let method: HTTPMethodType
    public let headerParameters: [String : String]
    

    public var queryParameters: [String: Any] {
        _queryParametersEncodable?.toDictionary() ?? self._queryParameters
    }
    
    public var bodyParameters: [String : Any] {
        self._bodyParameters
    }
    
    private let _queryParameters: [String : Any]
    private let _queryParametersEncodable: Encodable?
    private let _bodyParameters: [String : Any]
    
    init(
        baseURL: String,
        path: String,
        method: HTTPMethodType,
        headerParameters: [String : String] = [:],
        queryParameters: [String : Any] = [:],
        queryParametersEncodable: Encodable? = nil,
        bodyParameters: [String : Any] = [:]
    ) {
        // baseURL 끝 / 있을 시 삭제
        self.baseURL = baseURL.last == "/" ? String(baseURL.dropLast()) : baseURL
        // path 앞 / 없을 시 추가
        self.path = path.first == "/" ? path : "/\(path)"
        self.method = method
        self.headerParameters = headerParameters
        self._queryParameters = queryParameters
        self._queryParametersEncodable = queryParametersEncodable
        self._bodyParameters = bodyParameters
    }
}

public protocol Requestable {
    associatedtype Response
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParameters: [String: Any] { get }
    var bodyParameters: [String: Any] { get }
    
    // encodable ...
}

extension Requestable {
    func url() -> URL? {
        // base last 슬래쉬 제거 후 fullPath 조합, 기능 중복 ???: url 메소드 내 로직은 삭제?
        let baseURL: String = baseURL.last == "/" ? String(baseURL.dropLast()) : baseURL
        let fullPath: String = path.first == "/" ? "\(baseURL)\(path)" : "\(baseURL)/\(path)"
        guard var urlComponents = URLComponents(string: fullPath) else {
            return nil
        }
        var urlQueryItem: [URLQueryItem] = []
        
        let queryParameters = queryParameters
        queryParameters.forEach {
            urlQueryItem.append(.init(name: $0.key, value: "\($0.value)"))
        }
        urlComponents.queryItems = !urlQueryItem.isEmpty ? urlQueryItem : nil
        guard let url = urlComponents.url else {
            return nil
        }
        return url
    }
    
    public func asURLRequest() -> URLRequest? {
        guard let url = url() else { return nil }
        var urlRequest = URLRequest(url: url)
        
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters)
        }
        urlRequest.httpMethod = method.rawValue
        headerParameters.forEach{ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
    }
}

