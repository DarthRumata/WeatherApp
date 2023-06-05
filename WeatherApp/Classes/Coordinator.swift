//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import UIKit

protocol Route {
    
}

protocol Router {
    associatedtype RouteType: Route
    
    func trigger(route: RouteType)
}

extension Coordinator {
    func eraseToAnyRouter() -> AnyRouter<RouteType> {
        return AnyRouter(coordinator: self)
    }
}

protocol Coordinator: Router {
    func eraseToAnyRouter() -> AnyRouter<RouteType>
}

protocol ViewCoordinator: Coordinator {
    func buildFlow() -> UIViewController
}

final class AnyRouter<RouteType: Route>: Router {
    private let _trigger: (RouteType) -> Void
    
    init<C: Coordinator>(coordinator: C) where C.RouteType == RouteType {
        self._trigger = coordinator.trigger(route:)
    }
    
    func trigger(route: RouteType) {
        _trigger(route)
    }
}
