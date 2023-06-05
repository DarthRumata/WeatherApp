//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 04.06.2023.
//

import Combine
import Foundation

struct FormattedWeatherLocation: Identifiable {
    let id: String
    let address: String
}

class SearchViewModel: ObservableObject {
    // MARK: Output
    @Published var searchResults: [FormattedWeatherLocation]
    @Published var query: String = ""
    @Published var isLoading: Bool
    
    // MARK: Input
    var onTapCloseButton: () -> Void
    var onTapLocation: (String) -> Void
    
    private var cancellables = Set<AnyCancellable>()
    
    init(domainModel: SearchDomainModel) {
        func format(location: WeatherLocation) -> FormattedWeatherLocation {
            let state = location.state != nil ? " \(location.state ?? "")," : ""
            return FormattedWeatherLocation(
                id: location.id,
                address: "\(location.name),\(state) \(location.countryCode)"
            )
        }
        
        searchResults = domainModel.searchResults.map(format(location:))
        onTapCloseButton = { domainModel.handleClose() }
        onTapLocation = { domainModel.handleSelectionOfLocation(withId: $0) }
        isLoading = domainModel.isLoading
        
        domainModel.$searchResults
            .receive(on: DispatchQueue.main)
            .map { locations in
                locations.map(format(location:))
            }
            .assign(to: &$searchResults)
        
        domainModel.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoading)
        
        $query
            .dropFirst()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { query in
                domainModel.handleSearchQuery(query)
            }
            .store(in: &cancellables)
    }
}
