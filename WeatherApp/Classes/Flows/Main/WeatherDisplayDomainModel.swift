//
//  MainDomainModel.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Foundation
import CoreLocation
import Combine

enum WeatherFailureReason {
    case networkError
    case locationUnavailable
    case locationPermissionNotGranted
}

enum WeatherStatus {
    case loading
    case loaded(Weather, SelectedWeatherLocation)
    case failed(WeatherFailureReason)
}

class WeatherDisplayDomainModel {
    // MARK: Output
    @Published private(set) var weatherStatus: WeatherStatus = .loading
    
    // MARK: Dependencies
    private let weatherService: WeatherNetworkServiceProtocol
    private let locationService: LocationServiceProtocol
    private let selectedLocationRepository: SelectedLocationRepositoryProtocol
    private let router: AnyRouter<WeatherDisplayRoute>
    
    // MARK: State
    private var cancellables = Set<AnyCancellable>()
    
    init(weatherService: WeatherNetworkServiceProtocol, locationService: LocationServiceProtocol, selectedLocationRepository: SelectedLocationRepositoryProtocol, router: AnyRouter<WeatherDisplayRoute>) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.selectedLocationRepository = selectedLocationRepository
        self.router = router
        
        // Monitoring changes in location to load new weather data
        selectedLocationRepository.selectedLocationPublisher
            .sink { [weak self] location in
                guard let self else { return }
                
                self.updateData(for: location)
            }
            .store(in: &cancellables)
        
        // TODO: It make sense to add long-polling logic to update weather by timer but it will go beyond current demo
    }
    
    // MARK: Input
    func handleReload() {
        updateData(for: selectedLocationRepository.selectedLocation)
    }
    
    func handleSearch() {
        router.trigger(route: .openSearch)
    }
    
    func handleSwitchToCurrentLocation() {
        fetchCurrentLocation()
    }
    
    // MARK: Inner logic
    private func updateData(for location: SelectedWeatherLocation?) {
        if let location {
            Task {
                await updateWeather(at: location)
            }
        } else {
            fetchCurrentLocation()
        }
    }
    
    private func fetchCurrentLocation() {
        weatherStatus = .loading
        Task {
            switch locationService.status {
            case .authorized:
                await updateLocation()
            case .unavailable:
                weatherStatus = .failed(.locationUnavailable)
            case .manuallyDisabled:
                weatherStatus = .failed(.locationPermissionNotGranted)
            case .notDetermined:
                await handleAuthorizationThenUpdateLocation()
            }
        }
    }
    
    private func handleAuthorizationThenUpdateLocation() async {
        let result = await locationService.requestAuthorization()
        switch result {
        case .success:
            await updateLocation()
        case .failure(let error):
            switch error {
            case .unavailable:
                weatherStatus = .failed(.locationUnavailable)
            case .manuallyDisabled:
                weatherStatus = .failed(.locationPermissionNotGranted)
            }
        }
    }
    
    private func updateLocation() async {
        let result = await locationService.getCurrentUserLocation()
        switch result {
        case .success(let coordinate):
            let location = SelectedWeatherLocation.makeCurrentUserLocation(with: coordinate)
            selectedLocationRepository.setSelectedLocation(location)
        case .failure(let error):
            switch error {
            case .locationUnknown:
                weatherStatus = .failed(.locationUnavailable)
            }
        }
    }
    
    private func updateWeather(at location: SelectedWeatherLocation) async {
        weatherStatus = .loading
        let result = await weatherService.getCurrentWeather(at: location.coordinate, measureUnits: .metric)
        switch result {
        case .success(let weather):
            weatherStatus = .loaded(weather, location)
        case .failure(let error):
            // TODO: each network error can be processed in some particular way
            print(error)
            weatherStatus = .failed(.networkError)
        }
    }
}
