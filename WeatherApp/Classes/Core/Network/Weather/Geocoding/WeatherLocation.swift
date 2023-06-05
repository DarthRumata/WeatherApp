//
//  WeatherLocation.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 04.06.2023.
//

import Foundation

struct WeatherLocationDTO: Decodable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}

struct WeatherLocation {
    // It helps to identify which location we want to select without any ambiguity
    let id = ProcessInfo.processInfo.globallyUniqueString
    let name: String
    let coordinate: Coordinate
    let countryCode: String
    let state: String?
}


