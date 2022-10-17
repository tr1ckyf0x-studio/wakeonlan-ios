//
//  Navigates.swift
//  
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import RouteComposer

/// Describes objects which can performed navigation
public protocol Navigates {
    func navigate(to route: Route?, completion: @escaping (RoutingResult) -> Void)
}

public extension Navigates {
    /// Preforms navigation in the App
    ///
    /// - Parameter route: Navigation route
    /// - Parameter completion: Handler that will be called after navigation process
    func navigate(to route: Route?, completion: @escaping (RoutingResult) -> Void = { _ in }) {
        guard
            let route = route
        else {
            let error = RoutingError.nilRoute
            return completion(.failure(error))
        }
        route.routeAction { completion($0) }
    }
}

public extension RoutingError {
    static var nilRoute: RoutingError {
        .generic(RoutingError.Context("Route is nil. Navigation cannot be performed"))
    }
}
