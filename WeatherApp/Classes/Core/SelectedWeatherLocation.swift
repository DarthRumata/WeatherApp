//
//  SelectedWeatherLocation.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 05.06.2023.
//

import Foundation

enum LocationType: Equatable, Codable {
    case currentUserLocation
    case selected(name: String)
}

struct SelectedWeatherLocation: Codable {
    let type: LocationType
    let coordinate: Coordinate
    
    var name: String {
        switch type {
        case .currentUserLocation:
            return "📌 Your current Location"
        case .selected(let name):
            return name
        }
    }
    
    init(location: WeatherLocation) {
        type = .selected(name: location.name)
        coordinate = Coordinate(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
    
    init(type: LocationType, coordinate: Coordinate) {
        self.type = type
        self.coordinate = coordinate
    }
    
    static func makeCurrentUserLocation(with coordinate: Coordinate) -> SelectedWeatherLocation {
        return SelectedWeatherLocation(type: .currentUserLocation, coordinate: coordinate)
    }
}
