//
//  WeatherDisplayComponent.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import NeedleFoundation

protocol MainDependencies: Dependency {
    var locationService: LocationServiceProtocol { get }
    var networkService: NetworkServiceProtocol { get }
}

class WeatherDisplayComponent: Component<MainDependencies> {
    var weatherService: WeatherNetworkServiceProtocol {
        return shared {
            WeatherNetworkService(networkService: dependency.networkService)
        }
    }
    var selectedLocationRepository: SelectedLocationRepositoryProtocol {
        return shared { SelectedLocationRepository() }
    }
    
    var searchComponent: SearchComponent {
        return SearchComponent(parent: self)
    }
    
    func coordinator() -> WeatherDisplayViewCoordinator {
        return WeatherDisplayViewCoordinator(component: self)
    }
}
