//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import Combine
import Foundation

struct FormattedWeather {
    let selectedLocationName: String
    let usesCurrentUserLocation: Bool
    let description: String
    let icon: URL
    let temperature: String
    let pressure: String
    let humidity: String
    let windSpeed: String
}

extension WeatherFailureReason: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network is unavailble. Please check your connection"
        case .locationUnavailable:
            return "Location is unavailble"
        case .locationPermissionNotGranted:
            return "Location permission is not granted. Please go to Settings and enable Location for this app"
        }
    }
}

class WeatherDisplayViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded
        case failed(WeatherFailureReason)
    }
    
    // MARK: Output
    @Published private(set) var isLoading: Bool = false
    @Published var error: WeatherFailureReason?
    @Published private(set) var weather: FormattedWeather?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Input
    let onTapReloadButton: () -> Void
    let onTapSearchButton: () -> Void
    let onTapLocationButton: () -> Void
    
    init(domainModel: WeatherDisplayDomainModel) {
        // We need these closures to avoid retain cycle which happens on direct reference to function
        onTapReloadButton = { domainModel.handleReload() }
        onTapSearchButton = { domainModel.handleSearch() }
        onTapLocationButton = { domainModel.handleSwitchToCurrentLocation() }
        
        domainModel.$weatherStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherStatus in
                switch weatherStatus {
                case .loading:
                    self?.isLoading = true
                    self?.error = nil
                case .loaded(let weather, let location):
                    self?.handleLoaded(weather: weather, location: location)
                case .failed(let reason):
                    self?.isLoading = false
                    self?.error = reason
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: Inner logic
    private func handleLoaded(weather: Weather, location: SelectedWeatherLocation) {
        // TODO: It is simplified formatting which doesn't include switch between metric and imperial systems
        self.weather = FormattedWeather(
            selectedLocationName: location.name,
            usesCurrentUserLocation: location.type == .currentUserLocation,
            description: weather.description.capitalized,
            icon: weather.icon,
            temperature: "\(Int(weather.temperature)) °C",
            pressure: "Pressure: \(weather.pressure) hPa",
            humidity: "Humidity: \(weather.humidity)%",
            windSpeed: "Wind speed: \(weather.temperature) km/h"
        )
        isLoading = false
    }
}
