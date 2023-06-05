//
//  Weather.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Foundation

// MARK: DTO
struct WeatherDTO: Decodable {
    let id: Int
    let description: String
    let icon: String
}

struct MainWeatherDTO: Decodable {
    let temp: Float
    let pressure: Float
    let humidity: Int
}

struct WindDTO: Decodable {
    let speed: Float
}

struct WeatherResponseDTO: Decodable {
    let weather: [WeatherDTO]
    let main: MainWeatherDTO
    let wind: WindDTO
}

// MARK: Entity
struct Weather {
    let description: String
    let icon: URL
    let temperature: Float
    let pressure: Float
    let humidity: Int
    let windSpeed: Float
}
