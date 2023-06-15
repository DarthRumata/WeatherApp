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

/// A service for executing network requests using a URLSession and optional request decorators.
///
/// Use this class to perform network requests in your app. You can pass in one or more decorator objects to modify outgoing requests as needed (e.g., by adding headers).
///
/// - Note: This implementation uses async/await syntax and requires Swift 5.5+.
class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decorators: [RequestDecorator]

    init(session: URLSession, decorators: [RequestDecorator]) {
        self.session = session
        self.decorators = decorators
    }

    /// Send an asynchronous network request using a generic type that conforms to 'NetworkRequest'.
    ///
    /// Use this method to send a single network request asynchronously. You must provide a concrete implementation of 'NetworkRequest' when calling this method, which will be used for constructing the URLRequest object sent over the network.
    ///
    /// This method returns a Result enum containing either parsed response data or an error if something goes wrong during execution.
    ///
    /// - Note: This implementation uses async/await syntax and requires Swift 5.5+.
    ///
    /// - Parameters:
    ///   - request: A concrete implementation of 'NetworkRequest' representing the network request to be sent.
    ///
    /// - Returns: A `Result` enum containing either parsed response data or an error if something goes wrong during execution.
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
