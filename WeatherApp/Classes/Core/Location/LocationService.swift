//
//  LocationService.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 03.06.2023.
//

import Foundation
import CoreLocation

enum LocationAuthorizationError: Error {
    case unavailable
    case manuallyDisabled
    
    init(status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .notDetermined:
            self = .unavailable
        case .denied:
            self = .manuallyDisabled
        case .authorizedAlways, .authorizedWhenInUse:
            // It is better to restrict access in production but create crash in dev env
            fallthrough
        @unknown default:
            assertionFailure("There shouldn't be error if access is granted")
            self = .unavailable
        }
    }
}

enum UserLocationError: Error {
    case locationUnknown
}

enum LocationServiceStatus {
    case authorized
    case unavailable
    case manuallyDisabled
    case notDetermined
    
    init(status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            self = .unavailable
        case .denied:
            self = .manuallyDisabled
        case .notDetermined:
            self = .notDetermined
        case .authorizedAlways, .authorizedWhenInUse:
            self = .authorized
        @unknown default:
            self = .notDetermined
        }
    }
}

protocol LocationServiceProtocol {
    var status: LocationServiceStatus { get }
    var trackedLocation: Coordinate? { get }
    
    func getCurrentUserLocation() async -> Result<Coordinate, UserLocationError>
    func requestAuthorization() async -> Result<Void, LocationAuthorizationError>
}

/// A service for managing location-related functionality.
///
/// The `LocationService` class provides methods and properties for accessing the user's current location and requesting location authorization.
class LocationService: LocationServiceProtocol {
    var status: LocationServiceStatus {
        LocationServiceStatus(status: manager.authorizationStatus)
    }
    // TODO: this location can contain seeked result if timestamp is recent enough. This logic is missed in current demo
    /// The most recently tracked location coordinate.
    var trackedLocation: Coordinate? {
        (manager.location?.coordinate).map { Coordinate($0) }
    }
    
    // We don't want to contaminate our service with NSObject sematic so separate delegate instance is encouraged
    private lazy var locationDelegate = LocationServiceDelegate()
    private lazy var manager: CLLocationManager = {
        // CLLocationManager should be always created on main thread
        DispatchQueue.main.sync {
            let manager = CLLocationManager()
            manager.delegate = locationDelegate
            return manager
        }
    }()
    
    private var isAuthorized: Bool {
        manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse
    }
    
    /// Retrieves the current user's location.
    ///
    /// - Returns: A `Result` object containing the current user's location coordinate on success, or a `UserLocationError` on failure.
    func getCurrentUserLocation() async -> Result<Coordinate, UserLocationError> {
        guard isAuthorized else {
            assertionFailure("You shouldn't call this method if there is no location permission acquired")
            return .failure(.locationUnknown)
        }
        
        return await withCheckedContinuation { continuation in
            locationDelegate.setLocationCallback { result in
                continuation.resume(returning: result.map { Coordinate($0.coordinate) })
            }
            
            manager.requestLocation()
        }
    }
    
    /// Requests location authorization from the user.
    ///
    /// - Returns: A `Result` object indicating the success or failure of the authorization request.
    func requestAuthorization() async -> Result<Void, LocationAuthorizationError> {
        if isAuthorized {
            return .success(())
        }
        
        guard manager.authorizationStatus == .notDetermined else {
            return .failure(makeNotAuthorizedError())
        }
        
        return await withCheckedContinuation { [weak self] continuation in
            self?.locationDelegate.setAuthorizationCallback {
                guard let self else { return }
                
                let result: Result = self.isAuthorized ? .success(()) : .failure(self.makeNotAuthorizedError())
                continuation.resume(returning: result)
            }
            // TODO: let's simplify to only request one type of location
            self?.manager.requestWhenInUseAuthorization()
        }
    }
    
    private func makeNotAuthorizedError() -> LocationAuthorizationError {
        return LocationAuthorizationError(status: manager.authorizationStatus)
    }
}

private typealias LocationCallback = (Result<CLLocation, UserLocationError>) -> Void

private class LocationServiceDelegate: NSObject, CLLocationManagerDelegate {
    private var locationCallback: (LocationCallback)?
    private var authorizationCallback: (() -> Void)?
    
    func setLocationCallback(_ callback: @escaping LocationCallback) {
        locationCallback = callback
    }
    
    func setAuthorizationCallback(_ callback: @escaping () -> Void) {
        authorizationCallback = callback
    }
    
    // MARK: Delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationCallback else {
            assertionFailure("You should set callback before requesting location")
            return
        }
        if let location = locations.first {
            locationCallback(.success(location))
        } else {
            locationCallback(.failure(UserLocationError.locationUnknown))
        }
        self.locationCallback = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let locationCallback else {
            assertionFailure("You should set callback before requesting location")
            return
        }
        
        // TODO: We still need to deal with the initial error
        locationCallback(.failure(UserLocationError.locationUnknown))
        self.locationCallback = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationCallback?()
        authorizationCallback = nil
    }
}
