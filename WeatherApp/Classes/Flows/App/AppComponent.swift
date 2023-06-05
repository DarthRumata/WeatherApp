//
//  AppComponent.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import NeedleFoundation
import UIKit

class AppComponent: BootstrapComponent {
    var networkService: NetworkServiceProtocol {
        return shared { NetworkService() }
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
