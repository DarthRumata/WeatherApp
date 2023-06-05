//
//  WeatherNetworkService.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Alamofire

// TODO: More specific error types can be added
enum WeatherNetworkServiceError: Error {
    case networkError(Error)
    case parsingError
}

protocol WeatherNetworkServiceProtocol {
    func getCurrentWeather(at location: Coordinate, measureUnits: WeatherUnits) async -> Result<Weather, WeatherNetworkServiceError>
    func getLocations(byName name: String) async -> Result<[WeatherLocation], WeatherNetworkServiceError>
}

class WeatherNetworkService: WeatherNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private lazy var weatherMapper = WeatherMapper()
    private lazy var locationMapper = WeatherLocationMapper()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    /// Retrieves the current weather information for the specified location using the provided measurement units.
    ///
    /// - Parameters:
    ///   - location: The coordinates of the location for which to fetch the weather.
    ///   - measureUnits: The measurement units to use for the weather information.
    /// - Returns: A `Result` object with either the fetched `Weather` object on success or a `WeatherNetworkServiceError` on failure.
    func getCurrentWeather(at location: Coordinate, measureUnits: WeatherUnits) async -> Result<Weather, WeatherNetworkServiceError> {
        return await networkService.execute(request: CurrentWeatherRequest(location: location, measureUnits: measureUnits))
            .mapError { .networkError($0) }
            .flatMap {
                guard let weather = weatherMapper.weather(from: $0) else {
                    return .failure(.parsingError)
                }
                
                return .success(weather)
            }
    }
    
    /// Retrieves weather locations based on the provided name query.
    ///
    /// - Parameter name: The name query to search for weather locations.
    /// - Returns: A `Result` object with either an array of `WeatherLocation` objects on success or a `WeatherNetworkServiceError` on failure.
    func getLocations(byName name: String) async -> Result<[WeatherLocation], WeatherNetworkServiceError> {
        return await networkService.execute(request: GeocodeLocationRequest(query: name))
            .mapError { .networkError($0) }
            .flatMap {
                let locations = $0.map { locationMapper.location(from: $0) }
                
                return .success(locations)
            }
    }
}
