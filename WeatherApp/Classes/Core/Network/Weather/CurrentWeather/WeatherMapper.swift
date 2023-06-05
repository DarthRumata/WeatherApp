//
//  WeatherMapper.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Foundation

private enum Constants {
    static let iconBasePath = "https://openweathermap.org/img/wn/"
    static let iconExtension = "@2x.png"
}

struct WeatherMapper {
    func weather(from dto: WeatherResponseDTO) -> Weather? {
        // TODO: Let's use only first item in array for the demo
        guard let weather = dto.weather.first else {
            return nil
        }
        return Weather(
            description: weather.description,
            icon: URL(filePath: Constants.iconBasePath)
                .appendingPathComponent(weather.icon + Constants.iconExtension),
            temperature: dto.main.temp,
            pressure: dto.main.pressure,
            humidity: dto.main.humidity,
            windSpeed: dto.wind.speed
        )
    }
}
