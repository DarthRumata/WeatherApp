

import NeedleFoundation
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class SearchDependencies0d9e9112458d01c702b3Provider: SearchDependencies {
    var weatherService: WeatherNetworkServiceProtocol {
        return weatherDisplayComponent.weatherService
    }
    var selectedLocationRepository: SelectedLocationRepositoryProtocol {
        return weatherDisplayComponent.selectedLocationRepository
    }
    private let weatherDisplayComponent: WeatherDisplayComponent
    init(weatherDisplayComponent: WeatherDisplayComponent) {
        self.weatherDisplayComponent = weatherDisplayComponent
    }
}
/// ^->AppComponent->WeatherDisplayComponent->SearchComponent
private func factorydf90e163cf7500885ebf252fa8e1a2a67c09f958(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SearchDependencies0d9e9112458d01c702b3Provider(weatherDisplayComponent: parent1(component) as! WeatherDisplayComponent)
}
private class MainDependenciesca717fbd4649c8762e14Provider: MainDependencies {
    var locationService: LocationServiceProtocol {
        return appComponent.locationService
    }
    var networkService: NetworkServiceProtocol {
        return appComponent.networkService
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->WeatherDisplayComponent
private func factory71a27bced920860c0dddf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MainDependenciesca717fbd4649c8762e14Provider(appComponent: parent1(component) as! AppComponent)
}

#else
extension AppComponent: Registration {
    public func registerItems() {


    }
}
extension SearchComponent: Registration {
    public func registerItems() {
        keyPathToName[\SearchDependencies.weatherService] = "weatherService-WeatherNetworkServiceProtocol"
        keyPathToName[\SearchDependencies.selectedLocationRepository] = "selectedLocationRepository-SelectedLocationRepositoryProtocol"
    }
}
extension WeatherDisplayComponent: Registration {
    public func registerItems() {
        keyPathToName[\MainDependencies.locationService] = "locationService-LocationServiceProtocol"
        keyPathToName[\MainDependencies.networkService] = "networkService-NetworkServiceProtocol"

    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->AppComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->WeatherDisplayComponent->SearchComponent", factorydf90e163cf7500885ebf252fa8e1a2a67c09f958)
    registerProviderFactory("^->AppComponent->WeatherDisplayComponent", factory71a27bced920860c0dddf47b58f8f304c97af4d5)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
