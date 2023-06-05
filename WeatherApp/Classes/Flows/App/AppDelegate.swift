//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import UIKit
import NeedleFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private(set) lazy var appComponent = AppComponent()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerProviderFactories()
        
        return true
    }

    // Scene management is removed in this app because we don't want to support multiple scenes for iPad
}

