//
//  SearchComponent.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import NeedleFoundation


protocol SearchDependencies: Dependency {
    var weatherService: WeatherNetworkServiceProtocol { get }
    var selectedLocationRepository: SelectedLocationRepositoryProtocol { get }
}

class SearchComponent: Component<SearchDependencies> {
    func coordinator(childFlowHandler: @escaping (SearchRoute) -> Void) -> SearchViewCoordinator {
        return SearchViewCoordinator(component: self, childFlowHandler: childFlowHandler)
    }
}
