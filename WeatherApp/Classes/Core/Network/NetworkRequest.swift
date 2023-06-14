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

// The NetworkRequest protocol represents a network request that can be converted to a URLRequest and has a corresponding Response type.
///
/// Types conforming to NetworkRequest should provide implementation for the following properties:
/// - path: The path component of the request URL.
/// - method: The HTTP method to be used for the request.
/// - `parameters`: The parameters to be included in the request.
/// - decodable: The type of the expected response, conforming to Decodable.
protocol NetworkRequest: URLRequestConvertible {
    associatedtype DeserializerType: Deserializer
    associatedtype SerializerType: Serializer
    
    typealias URLQueryParameters = [String: String]
    typealias Body = (serializer: SerializerType, payload: SerializerType.Payload)
    
    var path: String { get }
    var method: HTTPMethod { get }
    var urlQueryParameters: URLQueryParameters? { get }
    var bodySerialization: Body { get }
    var deserializer: DeserializerType { get }
}

extension NetworkRequest {
    var method: HTTPMethod {
        return .get
    }
    var deserializer: EmptyDeserializer {
        return EmptyDeserializer()
    }
    var urlQueryParameters: URLQueryParameters? {
        return nil
    }
    var bodySerialization: (EmptySerializer, Void) {
        return (EmptySerializer(), ())
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
        
        let body = try bodySerialization.serializer.serialize(payload: bodySerialization.payload)
        if !body.isEmpty {
            request.httpBody = body
        }
        
        return request
    }
}
