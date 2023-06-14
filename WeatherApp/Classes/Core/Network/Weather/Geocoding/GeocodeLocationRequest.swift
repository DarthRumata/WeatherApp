//
//  GeocodeLocationRequest.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 04.06.2023.
//

struct GeocodeLocationRequest: NetworkRequest {
    let path = "https://api.openweathermap.org/geo/1.0/direct"
    let urlQueryParameters: URLQueryParameters?
    // TODO: it is good to add FailableDecodable to keep response even if one item is broken
    // https://kenb.us/lossy-decodable-for-arrays
    let deserializer = JSONDeserializer<[WeatherLocationDTO]>()
    
    init(query: String) {
        // TODO: limit is hardcoded for now
        urlQueryParameters = ["q": query, "limit": "5"]
    }
}
