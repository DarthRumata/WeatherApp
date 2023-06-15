//
//  NetworkRequest.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case trace = "TRACE"
}

/// A protocol representing a network request that can be converted to a URLRequest.
protocol NetworkRequest: URLRequestConvertible {
    associatedtype DeserializerType: Deserializer
    associatedtype SerializerType: Serializer
    
    /// The type representing URL query parameters as key-value pairs.
    typealias URLQueryParameters = [String: String]
    
    var path: String { get }
    var method: HTTPMethod { get }
    var urlQueryParameters: URLQueryParameters? { get }
    var bodySerializer: SerializerType { get }
    var body: SerializerType.Payload { get }
    var deserializer: DeserializerType { get }
}

extension NetworkRequest {
    var method: HTTPMethod {
        return .get
    }
    var urlQueryParameters: URLQueryParameters? {
        return nil
    }
    var deserializer: EmptyDeserializer {
        return EmptyDeserializer()
    }
    
    func asURLRequest() throws -> URLRequest {
        guard var url = URL(string: path) else {
            throw NetworkError.invalidRequest(NSError(domain: URLError.errorDomain, code: URLError.badURL.rawValue))
        }
        
        if let urlQueryParameters {
            var items = [URLQueryItem]()
            for parameter in urlQueryParameters {
                let item = URLQueryItem(name: parameter.key, value: parameter.value)
                items.append(item)
            }
            url.append(queryItems: items)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let serializedBody = try bodySerializer.serialize(payload: body)
        if !serializedBody.isEmpty {
            request.httpBody = serializedBody
        }
        
        return request
    }
}

extension NetworkRequest where SerializerType == EmptySerializer {
    var body: SerializerType.Payload {
        return ()
    }
}

extension NetworkRequest where SerializerType.Payload == Void {
    var bodySerializer: EmptySerializer {
        return EmptySerializer()
    }
}
