//
//  CurrentWeatherRequest.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Alamofire

enum WeatherUnits: String {
    case metric
    case imperial
}

struct CurrentWeatherRequest: NetworkRequest {
    let path = "https://api.openweathermap.org/data/2.5/weather"
    let parameters: Alamofire.Parameters
    let decodable = WeatherResponseDTO.self
    
    init(location: Coordinate, measureUnits: WeatherUnits) {
        parameters = ["lat": location.latitude, "lon": location.longitude, "units": measureUnits.rawValue]
    }
}
