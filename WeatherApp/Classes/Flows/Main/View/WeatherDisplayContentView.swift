//
//  MainContentView.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import SwiftUI
import Toaster

struct WeatherDisplayContentView: View {
    @ObservedObject var viewModel: WeatherDisplayViewModel
   
    var body: some View {
        let toast = Binding<Toast?>(get: {
            guard let error = viewModel.error else {
                return nil
            }
            
            return Toast(message: error.localizedDescription, style: .error)
        }, set: { value, _ in
            if value == nil {
                DispatchQueue.main.async {
                    viewModel.error = nil
                }
            }
        })
        Group {
            if let weather = viewModel.weather {
                WeatherView(weather: weather) {
                    viewModel.onTapLocationButton()
                }
            } else if !viewModel.isLoading {
                Text("No weather data available")
            }
        }
        .toastView(toast: toast)
        .overlay {
            if viewModel.isLoading {
                LoadingIndicatorView()
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

