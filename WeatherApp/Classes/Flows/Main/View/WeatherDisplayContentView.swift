//
//  MainContentView.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import SwiftUI
import PopupView

struct WeatherDisplayContentView: View {
    @ObservedObject var viewModel: WeatherDisplayViewModel
    @State private var showError = false
   
    var body: some View {
        Group {
            if let weather = viewModel.weather {
                WeatherView(weather: weather) {
                    viewModel.onTapLocationButton()
                }
            } else if viewModel.state != .loading {
                Text("No weather data available")
            }
        }
        .overlay {
            if case .loading = viewModel.state {
                LoadingIndicatorView()
            }
        }
        .popup(isPresented: $showError) {
            if case .failed(let error) = viewModel.state {
                ErrorView(error: error) {
                    viewModel.onTapReloadButton()
                }
            }
        } customize: { options in
            options
                .type(.toast)
                .autohideIn(4)
                .position(.bottom)
                .dragToDismiss(true)
        }
        .onChange(of: viewModel.state) { newValue in
            if case .failed = viewModel.state {
                showError = true
            }
        }
    }
}

struct ErrorView: View {
    let error: WeatherFailureReason
    let onTapButton: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text(error.localizedDescription)
                .lineLimit(nil)
                .padding()
                .foregroundColor(.white)
            if error == .networkError {
                Button("Reload") {
                    onTapButton()
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.7))
        )
    }
}

