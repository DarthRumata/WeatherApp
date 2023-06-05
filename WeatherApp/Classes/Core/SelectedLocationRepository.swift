//
//  SelectedLocationRepository.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 04.06.2023.
//

import Foundation
import Combine

private enum Constants {
    static let userDefaultsKey = "selectedWeatherLocation"
}

protocol SelectedLocationRepositoryProtocol: SelectedLocationProvider {
    func setSelectedLocation(_ location: SelectedWeatherLocation)
}

protocol SelectedLocationProvider {
    var selectedLocation: SelectedWeatherLocation? { get }
    var selectedLocationPublisher: AnyPublisher<SelectedWeatherLocation?, Never> { get }
}

// TODO: We can also add reactivite monitoring of changes
/// A repository for managing the selected weather location.
///
/// The `SelectedLocationRepository` allows setting and retrieving the selected weather location.
/// It also provides a publisher to observe changes to the selected location.
class SelectedLocationRepository: SelectedLocationRepositoryProtocol {
    var selectedLocation: SelectedWeatherLocation? {
        return selectedLocationSubject.value
    }
    // TODO: It is possible to create same behaviour using AsyncStream which can be more consistent with async/await paradigm used in other services but for now, I use more familiar to me Combine
    var selectedLocationPublisher: AnyPublisher<SelectedWeatherLocation?, Never> {
        return selectedLocationSubject.eraseToAnyPublisher()
    }
    
    @UserDefaultsStorage<SelectedWeatherLocation?>(defaultValue: nil, Constants.userDefaultsKey)
    private(set) var selectedLocationStorage: SelectedWeatherLocation?
    private lazy var selectedLocationSubject = CurrentValueSubject<SelectedWeatherLocation?, Never>(selectedLocationStorage)
    
    private var cancellable: Cancellable?
    
    init() {
        cancellable = selectedLocationPublisher
            .dropFirst()
            .sink { [weak self] location in
                self?.selectedLocationStorage = location
            }
    }
    
    func setSelectedLocation(_ location: SelectedWeatherLocation) {
        selectedLocationSubject.value = location
    }
}
