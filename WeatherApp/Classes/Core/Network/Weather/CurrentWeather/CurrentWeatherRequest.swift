//
//  CurrentWeatherRequest.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

enum WeatherUnits: String {
    case metric
    case imperial
}

struct CurrentWeatherRequest: NetworkRequest {    
    let path = "https://api.openweathermap.org/data/2.5/weather"
    let urlQueryParameters: URLQueryParameters?
    let deserializer = JSONDeserializer<WeatherResponseDTO>()
    
    init(location: Coordinate, measureUnits: WeatherUnits) {
        urlQueryParameters = ["lat": "\(location.latitude)", "lon": "\(location.longitude)", "units": measureUnits.rawValue]
    }
}
