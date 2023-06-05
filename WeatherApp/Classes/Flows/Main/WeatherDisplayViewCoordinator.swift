//
//  MainViewCoordinator.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import UIKit

enum WeatherDisplayRoute: Route {
    case openSearch
}

class WeatherDisplayViewCoordinator: ViewCoordinator {
    private let component: WeatherDisplayComponent
    private var rootViewController: UIViewController?
    
    init(component: WeatherDisplayComponent) {
        self.component = component
    }
    
    func buildFlow() -> UIViewController {
        let domainModel = WeatherDisplayDomainModel(
            weatherService: component.weatherService,
            locationService: component.dependency.locationService,
            selectedLocationRepository: component.selectedLocationRepository,
            router: eraseToAnyRouter()
        )
        let viewModel = WeatherDisplayViewModel(domainModel: domainModel)
        let controller = WeatherDisplayViewController(viewModel: viewModel)
        
        rootViewController = controller
        
        return controller
    }
    
    func trigger(route: WeatherDisplayRoute) {
        switch route {
        case .openSearch:
            navigateToSearchScreen()
        }
    }
    
    private func navigateToSearchScreen() {
        let coordinator = component.searchComponent.coordinator { [weak self] route in
            switch route {
            case .closeFlow:
                self?.rootViewController?.dismiss(animated: true)
            }
        }
        
        let controller = coordinator.buildFlow()
        rootViewController?.present(controller, animated: true)
    }
}
