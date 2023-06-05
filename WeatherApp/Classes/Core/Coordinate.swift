//
//  Coordinate.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 05.06.2023.
//

import Foundation
import CoreLocation

// This is needed to avoid creation Codable for CLLocationCoordinate2D
// https://www.objc.io/blog/2018/10/23/custom-types-for-codable/
struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ clCoordinate: CLLocationCoordinate2D) {
        latitude = clCoordinate.latitude
        longitude = clCoordinate.longitude
    }
}
