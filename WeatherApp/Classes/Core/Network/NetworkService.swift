//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func execute<Request: NetworkRequest>(request: Request) async -> Result<Request.DeserializerType.Response, NetworkError>
}

enum ServerError: Error {
    case invalidResponse
}

enum NetworkError: Error {
    case invalidRequest(Error)
    case serverError(Error)
}

/// The NetworkService class is responsible for executing network requests using Alamofire and handling the response.
class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decorators: [RequestDecorator]

    init(session: URLSession, decorators: [RequestDecorator]) {
        self.session = session
        self.decorators = decorators
    }

    /// Executes the provided network request and returns the response as a Result object.
    ///
    /// - Parameters:
    /// - request: The network request to execute.
    ///
    /// - Returns: A Result object containing either the successful response or an AFError in case of failure.
    func execute<Request: NetworkRequest>(request: Request) async -> Result<Request.DeserializerType.Response, NetworkError> {
        var urlRequest: URLRequest
        do {
            urlRequest = try request.asURLRequest()
            for decorator in decorators {
                urlRequest = decorator.decorate(urlRequest)
            }
        } catch let error {
            return .failure(.invalidRequest(error))
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse, (200...300).contains(response.statusCode) else {
                return .failure(.serverError(ServerError.invalidResponse))
            }
            let parsedResponse = try request.deserializer.deserialize(data: data)
            return .success(parsedResponse)
        } catch let error {
            return .failure(.serverError(error))
        }
    }
}
