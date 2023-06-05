//
//  LoadingIndicatorView.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 05.06.2023.
//

import SwiftUI

struct LoadingIndicatorView: View {
    var body: some View {
        ProgressView {
            Text("Loading...")
                .foregroundColor(.black.opacity(0.9))
                .padding(EdgeInsets(top: 1, leading: 10, bottom: 10, trailing: 10))
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white.opacity(0.95))
                .shadow(radius: 2)
                .padding(.top, -10)
        }
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatorView()
    }
}
