//
//  SearchViewCoordinator.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import UIKit

enum SearchRoute: Route {
    case closeFlow
}

class SearchViewCoordinator: ViewCoordinator {
    private let component: SearchComponent
    private let childFlowHandler: (SearchRoute) -> Void
    
    init(component: SearchComponent, childFlowHandler: @escaping (SearchRoute) -> Void) {
        self.component = component
        self.childFlowHandler = childFlowHandler
    }
    
    func buildFlow() -> UIViewController {
        let domainModel = SearchDomainModel(
            weatherService: component.dependency.weatherService,
            selectedLocationRepository: component.dependency.selectedLocationRepository,
            router: eraseToAnyRouter()
        )
        let viewModel = SearchViewModel(domainModel: domainModel)
        
        return SearchViewController(viewModel: viewModel)
    }
    
    func trigger(route: SearchRoute) {
        switch route {
        case .closeFlow:
            childFlowHandler(route)
        }
    }
}
