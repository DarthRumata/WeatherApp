//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Alamofire
import Foundation

protocol NetworkServiceProtocol {
    func execute<R: NetworkRequest>(request: R) async -> Result<R.Response, AFError>
}

/// The NetworkService class is responsible for executing network requests using Alamofire and handling the response.
class NetworkService: NetworkServiceProtocol {
    // TODO: more configuration can be added here
    private let session = Session.default
    // TODO: It should be moved to adapter network layer
    private lazy var weatherAdapter = WeatherSessionAdapter()
    
    /// Executes the provided network request and returns the response as a Result object.
    ///
    /// - Parameters:
    /// - request: The network request to execute.
    ///
    /// - Returns: A Result object containing either the successful response or an AFError in case of failure.
    func execute<R: NetworkRequest>(request: R) async -> Result<R.Response, AFError> {
        // TODO: This serializing is very simple just for demo
        let dataTask = session.request(request, interceptor: weatherAdapter)
            .serializingDecodable(request.decodable)
        return await dataTask.result
    }
}
