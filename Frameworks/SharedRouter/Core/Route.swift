//
//  Route.swift
//  
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import RouteComposer

/// Describes route that must be used for navigation
public struct Route {
    public typealias CompletionHandler = (RoutingResult) -> Void
    public typealias RouteAction = (@escaping CompletionHandler) -> Void

    // MARK: - Properties

    /// Internal storage
    internal let routeAction: RouteAction

    // MARK: - Init

    /// Initializer
    ///
    /// - Parameter routeAction: Action, that should be performed after navigation process
    public init(_ routeAction: @escaping RouteAction) {
        self.routeAction = routeAction
    }
}
