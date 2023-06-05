//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var appComponent: AppComponent? {
        return (UIApplication.shared.delegate as? AppDelegate)?.appComponent
    }
    private var appRouter: AnyRouter<AppRoute>?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        guard let appComponent = appComponent else {
            // Should be some proper logging
            assertionFailure("AppComponent wasn't loaded")
            return
        }
        
        let coordinator = appComponent.coordinator(window: window)
        coordinator.startFlow()
        appRouter = coordinator.eraseToAnyRouter()
    }
}

