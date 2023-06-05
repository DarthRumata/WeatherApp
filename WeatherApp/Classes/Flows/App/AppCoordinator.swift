//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import UIKit

enum AppRoute: Route {
    
}

class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let component: AppComponent
    
    init(component: AppComponent, window: UIWindow) {
        self.component = component
        self.window = window
    }
    
    func trigger(route: AppRoute) {
        
    }
    
    func startFlow() {
        let mainCoordinator = component.mainComponent.coordinator()
        let mainController = mainCoordinator.buildFlow()
        let navigation = UINavigationController(rootViewController: mainController)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
}
