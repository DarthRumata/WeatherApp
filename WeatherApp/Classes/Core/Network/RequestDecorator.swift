//
//  RequestDecorator.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 13.06.2023.
//

import Foundation

protocol RequestDecorator {
    func decorate(_ request: URLRequest) -> URLRequest
}
