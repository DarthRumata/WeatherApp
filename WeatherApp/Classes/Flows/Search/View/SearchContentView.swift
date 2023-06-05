//
//  SearchContentView.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 04.06.2023.
//

import SwiftUI

struct SearchContentView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.searchResults) { location in
                        Text(location.address)
                            .onTapGesture {
                                viewModel.onTapLocation(location.id)
                            }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Close") {
                            viewModel.onTapCloseButton()
                        }
                    }
                }
                .navigationTitle("Search")
                
                if viewModel.isLoading {
                    LoadingIndicatorView()
                }
            }
            
        }
        .searchable(text: $viewModel.query, prompt: "Enter US city name")
    }
}

