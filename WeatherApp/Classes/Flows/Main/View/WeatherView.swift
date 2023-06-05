//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 04.06.2023.
//

import SwiftUI
import Kingfisher

private enum Constants {
    static let bigImageSize: CGFloat = 180
    static let smallImageSize: CGFloat = 80
}

struct WeatherView: View {
    let weather: FormattedWeather
    let onTapCurrentLocationButton: () -> Void
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        let imageSize = verticalSizeClass == .compact ? Constants.smallImageSize : Constants.bigImageSize
        
        VStack(spacing: 5) {
            Text(weather.selectedLocationName)
                .padding()
                .font(.headline)
                .foregroundColor(.white)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.8))
                }
                .padding(.top, 25)
            
            Button("Use location") {
                onTapCurrentLocationButton()
            }
            .opacity(weather.usesCurrentUserLocation ? 0 : 1)
            // TODO: Weather icon looks blurry. It is not clear how to get more quality image
            KFImage.url(weather.icon)
                .placeholder {
                    // Setting placeholder when image cannot be retrived
                    Image(systemName: "arrow.2.circlepath.circle")
                        .font(.largeTitle)
                        .opacity(0.3)
                }
                .loadDiskFileSynchronously()
                .fade(duration: 0.25)
                .onProgress { receivedSize, totalSize in  }
                .onFailure { error in
                    print(error)
                }
                .resizable()
                .frame(width: imageSize, height: imageSize)
            Text(weather.description)
            Text(weather.temperature)
                .bold()
                .font(.title)
                .padding(.bottom, 20)
            if verticalSizeClass == .compact {
                HStack {
                    bottomParameters()
                }
            } else {
                bottomParameters()
            }
            Spacer()
        }
    }
    
    private func bottomParameters() -> some View {
        return Group {
            Text(weather.windSpeed)
            Text(weather.pressure)
            Text(weather.humidity)
        }
    }
}
