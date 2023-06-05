//
//  WeatherSessionAdapter.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Alamofire
import Foundation

private enum Constants {
    // TODO: Key should be secured in some secure storage like iCloud Container
    static let key = "c8b505f67304ef58bd13af86cc3b2b2a"
}

/// The WeatherSessionAdapter struct is a request interceptor that adapts the given URLRequest for a session, adding the "appid" parameter with the API key to the request.
///
/// The WeatherSessionAdapter conforms to the RequestInterceptor protocol, which allows it to modify the request before it is sent to the server.
struct WeatherSessionAdapter: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        do {
            let secureRequest = try URLEncoding.default.encode(urlRequest, with: ["appid": Constants.key])
            completion(.success(secureRequest))
        } catch let error {
            completion(.failure(error))
        }
    }
}
