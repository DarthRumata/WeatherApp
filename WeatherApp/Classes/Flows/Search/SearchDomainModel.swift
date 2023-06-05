//
//  SearchDomainModel.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 04.06.2023.
//

import Foundation

class SearchDomainModel {
    @Published private(set) var isLoading = false
    @Published private(set) var searchResults = [WeatherLocation]()
    
    private let weatherService: WeatherNetworkServiceProtocol
    private let selectedLocationRepository: SelectedLocationRepositoryProtocol
    private let router: AnyRouter<SearchRoute>
    
    init(weatherService: WeatherNetworkServiceProtocol, selectedLocationRepository: SelectedLocationRepositoryProtocol, router: AnyRouter<SearchRoute>) {
        self.weatherService = weatherService
        self.selectedLocationRepository = selectedLocationRepository
        self.router = router
    }
    
    func handleClose() {
        router.trigger(route: .closeFlow)
    }
    
    func handleSearchQuery(_ query: String) {
        guard query.count > 1 else {
            searchResults.removeAll()
            return
        }
        isLoading = true
        Task {
            let result = await weatherService.getLocations(byName: query)
            switch result {
            case .success(let locations):
                searchResults = locations
            case .failure(let error):
                print(error)
            }
            isLoading = false
        }
    }
    
    func handleSelectionOfLocation(withId id: String) {
        guard let location = searchResults.first(where: { $0.id == id }) else {
            print("Search result doesn't exist anymore")
            return
        }
        
        selectedLocationRepository.setSelectedLocation(SelectedWeatherLocation(location: location))
        router.trigger(route: .closeFlow)
    }
}
