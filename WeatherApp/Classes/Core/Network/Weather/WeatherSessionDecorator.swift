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

/// The WeatherSessionAdapter struct is a request interceptor that adapts the given URLRequest for a session, adding the "appid" parameter with the API key to the request.
///
/// The WeatherSessionAdapter conforms to the RequestInterceptor protocol, which allows it to modify the request before it is sent to the server.
struct WeatherSessionDecorator: RequestDecorator {
    func decorate(_ request: URLRequest) -> URLRequest {
        var decoratedRequest = request
        let tokenQueryItem = URLQueryItem(name: "appid", value: Constants.key)
        let url = request.url?.appending(queryItems: [tokenQueryItem])
        decoratedRequest.url = url
        return decoratedRequest
    }
}
