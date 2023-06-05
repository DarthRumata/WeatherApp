//
//  NetworkRequest.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Foundation
import Alamofire

// TODO: It is very simplified version of request that works only for decodable responses
// The NetworkRequest protocol represents a network request that can be converted to a URLRequest and has a corresponding Response type.
///
/// Types conforming to NetworkRequest should provide implementation for the following properties:
/// - path: The path component of the request URL.
/// - method: The HTTP method to be used for the request.
/// - `parameters`: The parameters to be included in the request.
/// - decodable: The type of the expected response, conforming to Decodable.
protocol NetworkRequest: URLRequestConvertible {
    associatedtype Response: Decodable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var decodable: Response.Type { get }
}

extension NetworkRequest {
    var method: HTTPMethod {
        return .get
    }
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: path)
        guard let url else {
            throw AFError.invalidURL(url: path)
        }
        var request = URLRequest(url: url)
        request.method = method
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
