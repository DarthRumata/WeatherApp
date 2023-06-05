//
//  WeatherLocationMapper.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 04.06.2023.
//

import CoreLocation

struct WeatherLocationMapper {
    func location(from dto: WeatherLocationDTO) -> WeatherLocation {
        return WeatherLocation(
            name: dto.name,
            coordinate: Coordinate(latitude: dto.lat, longitude: dto.lon),
            countryCode: dto.country,
            state: dto.state
        )
    }
}
