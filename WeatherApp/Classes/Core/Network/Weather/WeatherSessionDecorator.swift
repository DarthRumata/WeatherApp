//
//  WeatherSessionAdapter.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Foundation

private enum Constants {
    // TODO: Key should be secured in some secure storage like iCloud Container
    static let key = "c8b505f67304ef58bd13af86cc3b2b2a"
}

/// A request decorator that adds the weather API key to the request.
struct WeatherSessionDecorator: RequestDecorator {
    // Decorates the provided request by adding the weather API key as a query parameter.
    /// - Parameter request: The original request to be decorated.
    /// - Returns: The decorated request with the weather API key added.
    func decorate(_ request: URLRequest) -> URLRequest {
        var decoratedRequest = request
        let tokenQueryItem = URLQueryItem(name: "appid", value: Constants.key)
        let url = request.url?.appending(queryItems: [tokenQueryItem])
        decoratedRequest.url = url
        return decoratedRequest
    }
}
