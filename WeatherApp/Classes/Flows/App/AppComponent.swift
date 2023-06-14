//
//  AppComponent.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import NeedleFoundation
import UIKit

protocol URLSessionProvider {
    var session: URLSession { get }
}

class SessionService: URLSessionProvider {
    private(set) lazy var session: URLSession = URLSession(configuration: .default)
}

class AppComponent: BootstrapComponent {
    var urlSessionProvider: URLSessionProvider {
        return shared { SessionService() }
    }
    
    var locationService: LocationServiceProtocol {
        return shared { LocationService() }
    }
    
    var mainComponent: WeatherDisplayComponent {
        return WeatherDisplayComponent(parent: self)
    }
    
    func coordinator(window: UIWindow) -> AppCoordinator {
        return AppCoordinator(component: self, window: window)
    }
}
